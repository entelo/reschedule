module RescheduleSpecHelper
  extend RSpec::SharedContext

  def stub_json(method, url, response_data)
    response = {
      status: 200,
      body: response_data.to_json,
      headers: { 'Content-Type' => 'application/json' }
    }
    stub_request(:get, url).to_return(response)
  end

  def create_replication_controller(image)
    Hashie::Mash.new(
      metadata: {
        name: 'foo',
        spec: {
          replicas: 1
        }
      },
      spec: {
        table: {
          template: {
            spec: {
              containers: [
                {
                  image: image
                }
              ]
            }
          }
        }
      }
    )
  end

  before :each do
    Reschedule.configure do |config|
      config.kubernetes_api_url = "https://#{kube_host}/api/"
      config.kubernetes_api_username = kube_username
      config.kubernetes_api_password = kube_password
      config.dry_run = dry_run
    end
  end

  let(:kube_host) { 'kube.local' }
  let(:kube_username) { 'foo' }
  let(:kube_password) { 'bar' }
  let(:kube_url) { "https://#{kube_username}:#{kube_password}@#{kube_host}/api/" }
  let(:heapster_url) { "#{kube_url}v1/proxy/namespaces/kube-system/services/heapster/api/v1/" }
  let(:dry_run) { false }

  let(:node_names) { (0..1).map { |i| "node-#{i}.compute.internal" } }
  let(:replication_controller_names) { (0..1).map { |i| "rc-#{i}" } }

  let(:node_stats) { [node_stat_default, node_stat_default] }
  let(:nodes) do
    (0..1).map do |i|
      {
        'name' => node_names[i],
        'cpuUsage' => 306,
        'memUsage' => 2831523840
      }
    end
  end
  let(:pods) { [pod_default] }
  let(:replication_controllers) { [double.as_null_object] }

  let(:node_stat_default) do
    {
     "uptime"=>401576,
     "stats"=>
      {"cpu-limit"=>
        {"minute"=>{"average"=>36000, "percentile"=>36000, "max"=>36000},
         "hour"=>{"average"=>36000, "percentile"=>36000, "max"=>36000},
         "day"=>{"average"=>36000, "percentile"=>36000, "max"=>36000}},
       "cpu-usage"=>
        {"minute"=>{"average"=>306, "percentile"=>306, "max"=>306}, "hour"=>{"average"=>317, "percentile"=>340, "max"=>350}, "day"=>{"average"=>316, "percentile"=>330, "max"=>330}},
       "memory-limit"=>
        {"minute"=>{"average"=>63317110784, "percentile"=>63317110784, "max"=>63317110784},
         "hour"=>{"average"=>63317213184, "percentile"=>63317213184, "max"=>63317213184},
         "day"=>{"average"=>63317213184, "percentile"=>63317213184, "max"=>63317213184}},
       "memory-usage"=>
        {"minute"=>{"average"=>4992581632, "percentile"=>4992581632, "max"=>4992581632},
         "hour"=>{"average"=>4982343816, "percentile"=>4991221760, "max"=>4995416064},
         "day"=>{"average"=>4968991948, "percentile"=>4978638848, "max"=>4979036160}},
       "memory-working"=>
        {"minute"=>{"average"=>2815111168, "percentile"=>2815111168, "max"=>2815111168},
         "hour"=>{"average"=>2810043869, "percentile"=>2814377984, "max"=>2818572288},
             "day"=>{"average"=>2805639850, "percentile"=>2810183680, "max"=>2810183680}}}}
  end

  let(:pod_default) do
    Hashie::Mash.new({
      spec: { nodeName: node_names[0] },
      metadata: {
        annotations: {
          'kubernetes.io/created-by' => {
            reference: { name: replication_controller_names[0] }
          }.to_json
        },
        namespace: 'default'
      }
    })
  end
end
