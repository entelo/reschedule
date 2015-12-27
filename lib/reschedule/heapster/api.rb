module Reschedule
  module Heapster
    class Api
      def get_node_stats(node_name)
        get("model/nodes/#{node_name}/stats/")
      end

      def get_nodes
        get('model/nodes/')
      end

      private

      def get(path)
        auth = {
          username: Reschedule.configuration.kubernetes_api_username,
          password: Reschedule.configuration.kubernetes_api_password
        }
        base_url = "#{Reschedule.configuration.kubernetes_api_url}v1/proxy/namespaces/kube-system/services/heapster/api/v1/"
        url = "#{base_url}#{path}"
        HTTParty.get(url, basic_auth: auth, verify: false)
      end
    end
  end
end
