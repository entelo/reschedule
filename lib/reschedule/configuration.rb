module Reschedule
  class Configuration
    attr_accessor :dry_run, :kubernetes_api_url, :kubernetes_api_username, :kubernetes_api_password,
      :namespace, :memory_threshold, :run_interval

    def initialize
      self.dry_run = ENV['RESCHEDULE_DRY_RUN'] == '1'
      self.kubernetes_api_url = ENV['KUBERNETES_API_URL']
      self.kubernetes_api_username = ENV['KUBERNETES_API_USERNAME']
      self.kubernetes_api_password = ENV['KUBERNETES_API_PASSWORD']
      self.memory_threshold = ENV['MEMORY_THRESHOLD'].presence.try(:to_f) || 0.8
      self.namespace = ENV['RESCHEDULE_NAMESPACE'].presence || 'default'
      self.run_interval = ENV['RUN_INTERVAL'].presence || '5m'
    end
  end
end
