module Reschedule
  class Configuration
    attr_accessor :dry_run, :kubernetes_api_url, :kubernetes_api_username, :kubernetes_api_password,
      :kubernetes_api_client_key, :kubernetes_api_client_cert, :kubernetes_api_ca_file

    def initialize
      self.dry_run = ENV['RESCHEDULE_DRY_RUN'] == '1'
      self.kubernetes_api_url = ENV['KUBERNETES_API_URL']
      self.kubernetes_api_username = ENV['KUBERNETES_API_USERNAME']
      self.kubernetes_api_password = ENV['KUBERNETES_API_PASSWORD']
      self.kubernetes_api_client_key = ENV['KUBERNETES_API_CLIENT_KEY']
      self.kubernetes_api_client_cert = ENV['KUBERNETES_API_CLIENT_CERT']
      self.kubernetes_api_ca_file = ENV['KUBERNETES_API_CA_FILE']
    end
  end
end
