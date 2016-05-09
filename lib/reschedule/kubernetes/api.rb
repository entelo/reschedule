module Reschedule
  module Kubernetes
    class Api
      attr_accessor :client

      def initialize
        self.client = Kubeclient::Client.new(Reschedule.configuration.kubernetes_api_url, 'v1', client_options)
      end

      def method_missing(method, *args)
        self.client.public_send(method, *args)
      end

      private

      def client_options
        client_options = {}
        if Reschedule.configuration.kubernetes_api_username.present?
          client_options[:auth_options] = {
            user: Reschedule.configuration.kubernetes_api_username,
            password: Reschedule.configuration.kubernetes_api_password
          }
        end
        if Reschedule.configuration.kubernetes_api_client_key.present?
          client_options[:ssl_options] = {
            client_key: Reschedule.configuration.kubernetes_api_client_key,
            client_cert: Reschedule.configuration.kubernetes_api_client_cert,
            ca_file: Reschedule.configuration.kubernetes_api_ca_file,
            verify_ssl: OpenSSL::SSL::VERIFY_PEER
          }
        end
        client_options
      end
    end
  end
end
