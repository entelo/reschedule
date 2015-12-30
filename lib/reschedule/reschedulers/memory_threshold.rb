module Reschedule
  module Reschedulers
    class MemoryThreshold < Base
      attr_reader :heapster_api, :kubernetes_api

      self.defaults = {
        'memory_threshold' => 0.8,
        'namespace' => 'default'
      }

      def initialize(options={})
        super
        @heapster_api = Reschedule::Heapster::Api.new
        @kubernetes_api = Reschedule::Kubernetes::Api.new
      end

      def run
        super
        node_names = rescheduleable_node_names
        Reschedule.logger.debug "Found #{node_names.length} rescheduleable nodes"
        return if node_names.blank?

        pods = get_pods
        Reschedule.logger.debug "Found #{pods.length} total pods"
        replication_controller_names = pods_and_node_names_to_replication_controller_names(pods, node_names)
        replication_controller_names.each do |replication_controller_name|
          reschedule_replication_controller(replication_controller_name)
        end
      end

      private

      def get_pods
        pods = kubernetes_api.get_pods
        pods.select { |pod| pod.metadata.namespace == options['namespace'] }
      end

      def pods_and_node_names_to_replication_controller_names(pods, node_names)
        node_pods = pods.select do |pod|
          node_names.include?(pod.spec.nodeName)
        end
        pods_to_replication_controller_names(node_pods)
      end

      def pods_to_replication_controller_names(pods)
        replication_controller_names = pods.map do |pod|
          created_by = pod.metadata.annotations['kubernetes.io/created-by']
          created_by = JSON.parse(created_by)
          created_by['reference']['name']
        end
        replication_controller_names.uniq
      end

      def reschedule_replication_controller(replication_controller_name)
        Reschedule.logger.debug "Rescheduling #{replication_controller_name}"
        return if Reschedule.configuration.dry_run

        replication_controller = kubernetes_api.get_replication_controllers(label_selector: "name=#{replication_controller_name}").first
        original_replicas = replication_controller.spec.replicas
        replication_controller.spec.replicas = 0
        kubernetes_api.update_replication_controller(replication_controller)
        sleep 0.5
        replication_controller.spec.replicas = original_replicas
        kubernetes_api.update_replication_controller(replication_controller)
        Reschedule.logger.debug "Rescheduled #{replication_controller_name}"
      end

      def rescheduleable_node_names
        nodes = heapster_api.get_nodes
        if nodes.code != 200
          Reschedule.logger.debug "Unable to get nodes in Heapster: #{nodes}"
          return
        end
        Reschedule.logger.debug "Found #{nodes.length} nodes in Heapster"
        nodes_to_rescheduleable_node_names(nodes)
      end

      def nodes_to_rescheduleable_node_names(nodes)
        rescheduleable_node_names = []
        nodes.each do |node|
          node_name = node['name']
          node_stats = heapster_api.get_node_stats(node_name)
          if node_stats.code != 200
            Reschedule.logger.debug "Node stats not found: #{node_stats}"
            next
          end
          memory_limit = node_stats['stats']['memory-limit']['hour']['average']
          memory_usage = node_stats['stats']['memory-usage']['hour']['average']
          if memory_usage.to_f / memory_limit > options['memory_threshold']
            rescheduleable_node_names << node_name
          end
        end
        rescheduleable_node_names
      end
    end
  end
end
