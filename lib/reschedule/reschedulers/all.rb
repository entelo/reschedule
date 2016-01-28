module Reschedule
  module Reschedulers
    class All < Base
      attr_reader :kubernetes_api, :replication_controller_name_regex

      self.defaults = {
        'namespace' => 'default'
      }

      def initialize(options={})
        super
        @kubernetes_api = Reschedule::Kubernetes::Api.new
        @replication_controller_name_regex = options['replication_controller_name_match'].present? ? Regexp.new(options['replication_controller_name_match']) : nil
      end

      def run
        super
        replication_controllers = kubernetes_api.get_replication_controllers(namespace: options['namespace'])
        Reschedule.logger.debug "Found #{replication_controllers.length} replication controllers"

        replication_controllers.select! do |replication_controller|
          Reschedule.logger.debug replication_controller.inspect
          image = replication_controller.spec['table'][:template]['spec']['containers'][0]['image']
          next if image.include?('/reschedule')
          next if replication_controller.spec.replicas == 0
          next if replication_controller_name_regex && replication_controller.metadata.name !~ replication_controller_name_regex
          true
        end

        Reschedule.logger.debug "Found #{replication_controllers.length} replication controllers to reschedule"
        replication_controllers.each do |replication_controller|
          reschedule_replication_controller(replication_controller.metadata.name)
        end
      end
    end
  end
end
