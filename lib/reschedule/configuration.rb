module Reschedule
  class Configuration
    attr_accessor :dry_run, :kubernetes_api_url, :kubernetes_api_username, :kubernetes_api_password

    def initialize
      self.dry_run = ENV['RESCHEDULE_DRY_RUN'] == '1'
      self.kubernetes_api_url = ENV['KUBERNETES_API_URL']
      self.kubernetes_api_username = ENV['KUBERNETES_API_USERNAME']
      self.kubernetes_api_password = ENV['KUBERNETES_API_PASSWORD']
    end
  end
end
