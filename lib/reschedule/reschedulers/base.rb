module Reschedule
  module Reschedulers
    class Base
      attr_reader :options

      class_attribute :defaults

      def initialize(options={})
        @options = options || {}
        @options.reverse_merge!(self.class.defaults)
      end

      def run
        Reschedule.logger.debug "Starting #{self.class.name}"
        Reschedule.logger.debug "Dry run mode is on" if Reschedule.configuration.dry_run
      end

      private

      def reschedule_replication_controller(replication_controller_name)
        Reschedule.logger.debug "Rescheduling #{replication_controller_name}"

        unless Reschedule.configuration.dry_run
          replication_controller = kubernetes_api.get_replication_controllers(label_selector: "name=#{replication_controller_name}").first
          original_replicas = replication_controller.spec.replicas
          replication_controller.spec.replicas = 0
          kubernetes_api.update_replication_controller(replication_controller)
          sleep 0.5
          replication_controller = kubernetes_api.get_replication_controllers(label_selector: "name=#{replication_controller_name}").first
          replication_controller.spec.replicas = original_replicas
          kubernetes_api.update_replication_controller(replication_controller)
        end

        Reschedule.logger.debug "Rescheduled #{replication_controller_name}"
      end
    end
  end
end
