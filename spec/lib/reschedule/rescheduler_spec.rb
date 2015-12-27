require 'spec_helper'

describe Reschedule::Rescheduler do
  include RescheduleSpecHelper

  describe '#run' do
    before :each do
      stub_json(:get, "#{heapster_url}model/nodes/", nodes)
      stub_json(:get, "#{heapster_url}model/nodes/#{node_names[0]}/stats/", node_stats[0])
      stub_json(:get, "#{heapster_url}model/nodes/#{node_names[1]}/stats/", node_stats[1])

      allow_any_instance_of(Reschedule::Kubernetes::Api).to receive(:get_replication_controllers).with(label_selector: "name=#{replication_controller_names[0]}").and_return(replication_controllers)
      allow_any_instance_of(Reschedule::Kubernetes::Api).to receive(:update_replication_controller)
      allow_any_instance_of(Reschedule::Kubernetes::Api).to receive(:get_pods).and_return(pods)
    end

    context 'memory threshold not exceeded' do
      it 'does not update any replication controllers' do
        expect_any_instance_of(Reschedule::Kubernetes::Api).to_not receive(:update_replication_controller)
        described_class.new.run
      end
    end

    context 'memory threshold exceeded' do
      let(:memory_threshold) { 0.01 }

      it 'updates the replication controller' do
        expect_any_instance_of(Reschedule::Kubernetes::Api).to receive(:update_replication_controller).with(replication_controllers[0])
        expect_any_instance_of(Reschedule::Kubernetes::Api).to receive(:update_replication_controller).with(replication_controllers[0])
        described_class.new.run
      end
    end

    context 'memory threshold exceeded in a non-default namespace' do
      let(:memory_threshold) { 0.01 }
      let(:pods) do
        pod = pod_default
        pod.metadata.namespace = 'foo'
        [pod]
      end

      it 'does not update any replication controllers' do
        expect_any_instance_of(Reschedule::Kubernetes::Api).to_not receive(:update_replication_controller)
        described_class.new.run
      end
    end
  end
end
