module Reschedule
  class Manager
    def run
      scheduler = Rufus::Scheduler.new

      config['reschedulers'].each do |rescheduler|
        klass = "Reschedule::Reschedulers::#{rescheduler['type']}".constantize
        scheduler.every rescheduler['every'] do
          klass.new(rescheduler['options']).run
        end
      end

      scheduler.join
    end

    private

    def config
      @config ||= YAML.load(File.read('./reschedule.yml'))
    end
  end
end
