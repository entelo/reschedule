module Reschedule
  module Kubernetes
    class Api
      attr_accessor :client

      def initialize
        self.client = Kubeclient::Client.new(Reschedule.configuration.kubernetes_api_url, 'v1',
          auth_options: {
            user: Reschedule.configuration.kubernetes_api_username,
            password: Reschedule.configuration.kubernetes_api_password
          },
          ssl_options: { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
        )
      end

      def method_missing(method, *args)
        self.client.public_send(method, *args)
      end
    end
  end
end
