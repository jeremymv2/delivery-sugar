require 'spec_helper'
require 'chef/resource'

describe Chef::Resource::DeliveryTerraForm do
  before(:each) do
    allow_any_instance_of(DeliverySugar::DSL).to receive(:node)
      .and_return(cli_node)
    @resource = described_class.new('unit_test')
  end

  describe '#initialize' do
    it 'creates a new Chef::Resource::DeliveryTerraForm with default attrs' do
      expect(@resource).to be_a(Chef::Resource)
      expect(@resource).to be_a(described_class)
      expect(@resource.provider).to be(Chef::Provider::DeliveryTerraForm)
      expect(@resource.repo_path).to eql('/workspace/path/to/phase/repo')
    end

    it 'has a resource name of :delivery_terraform' do
      expect(@resource.resource_name).to eql(:delivery_terraform)
    end
  end

  describe '#plan_dir' do
    it 'must be a string' do
      @resource.plan_dir '/some/path/to/plans'
      expect(@resource.plan_dir).to eql('/some/path/to/plans')
      expect { @resource.send(:plan_dir, ['r']) }.to raise_error(ArgumentError)
    end

    it 'is required' do
      resource = described_class.new('unit_test')
      expect { resource.plan_dir }.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end

  describe '#repo_path' do
    it 'requires an string' do
      @resource.repo_path '/path'
      expect(@resource.repo_path).to eql('/path')
      expect { @resource.send(:repo_path, 10) }.to raise_error(ArgumentError)
    end
  end
end
