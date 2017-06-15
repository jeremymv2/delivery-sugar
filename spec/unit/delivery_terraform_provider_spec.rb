require 'spec_helper'
require 'chef/node'
require 'chef/event_dispatch/dispatcher'
require 'chef/run_context'

describe Chef::Provider::DeliveryTerraForm do
  let(:node) { Chef::Node.new }
  let(:events) { Chef::EventDispatch::Dispatcher.new }
  let(:run_context) { Chef::RunContext.new(node, {}, events) }
  let(:new_resource) { Chef::Resource::DeliveryTerraForm.new('unit_test') }
  let(:provider) { described_class.new(new_resource, run_context) }

  before(:each) do
    allow_any_instance_of(DeliverySugar::DSL).to receive(:node)
      .and_return(cli_node)
  end

  let(:shellout_options) do
    {
      cwd: 'workspace/repo',
      live_stream: STDOUT
    }
  end

  context 'when called correctly' do
    before { new_resource.plan_dir '/path/to/plans' }

    describe '#initialize' do
      subject { provider.terraform }

      it 'creates a new DeliverySugar::DeliveryTerraForm with default attrs' do
        expect(subject).to be_a(DeliverySugar::TerraForm)
        expect(subject.repo_path).to eql('/workspace/path/to/phase/repo')
      end
    end

    describe '#action_init' do
      it 'calls a terraform init' do
        expect(provider.terraform).to receive(:run).with('init')
        provider.send(:action_init)
      end
    end

    describe '#action_plan' do
      it 'calls a terraform plan' do
        expect(provider.terraform).to receive(:run).with('plan')
        provider.send(:action_plan)
      end
    end

    describe '#action_apply' do
      it 'calls a terraform apply' do
        expect(provider.terraform).to receive(:run).with('apply')
        provider.send(:action_apply)
      end
    end

    describe '#action_show' do
      it 'calls a terraform show' do
        expect(provider.terraform).to receive(:run).with('show')
        provider.send(:action_show)
      end
    end

    describe '#action_destroy' do
      it 'calls a terraform destroy' do
        expect(provider.terraform).to receive(:run).with('destroy')
        provider.send(:action_destroy)
      end
    end

    describe '#action_test' do
      it 'calls a terraform init' do
        expect(provider.terraform).to receive(:run).with('init')
        provider.send(:action_init)
      end
      it 'calls a terraform plan' do
        expect(provider.terraform).to receive(:run).with('plan')
        provider.send(:action_plan)
      end
      it 'calls a terraform apply' do
        expect(provider.terraform).to receive(:run).with('apply')
        provider.send(:action_apply)
      end
      it 'calls a terraform show' do
        expect(provider.terraform).to receive(:run).with('show')
        provider.send(:action_show)
      end
      it 'calls a terraform destroy' do
        expect(provider.terraform).to receive(:run).with('destroy')
        provider.send(:action_destroy)
      end
    end
  end
end
