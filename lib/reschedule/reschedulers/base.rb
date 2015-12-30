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
    end
  end
end
