require 'spec_helper'

describe Reschedule::Reschedulers::All do
  include RescheduleSpecHelper

  describe '#run' do
    let(:reschedule_replication_controller) { create_replication_controller('foo.bar.com/reschedule:latest') }
    let(:other_replication_controller) { create_replication_controller('foo.bar.com/other:latest') }

    before :each do
      allow_any_instance_of(Reschedule::Kubernetes::Api).to receive(:get_replication_controllers).and_return(replication_controllers)
      allow_any_instance_of(Reschedule::Kubernetes::Api).to receive(:update_replication_controller)
      allow_any_instance_of(Reschedule::Kubernetes::Api).to receive(:get_pods).and_return(pods)
    end

    context 'default' do
      context 'other replication controller' do
        let(:replication_controllers) { [other_replication_controller] }

        it 'updates all of the replication controllers' do
          expect_any_instance_of(Reschedule::Kubernetes::Api).to receive(:update_replication_controller).with(replication_controllers[0])
          described_class.new.run
        end
      end

      context 'reschedule replication controller' do
        let(:replication_controllers) { [reschedule_replication_controller] }

        it 'does not update any replication controller' do
          expect_any_instance_of(Reschedule::Kubernetes::Api).to_not receive(:update_replication_controller)
          described_class.new.run
        end
      end
    end

    context 'dry run' do
      let(:dry_run) { true }

      it 'does not update any replication controllers' do
        expect_any_instance_of(Reschedule::Kubernetes::Api).to_not receive(:update_replication_controller)
        described_class.new.run
      end
    end
  end
end
