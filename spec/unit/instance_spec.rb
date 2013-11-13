require 'spec_helper'

describe SemiAuto::Instance do
  let(:attributes) { { tag_set: [] } }
  let(:instance) { SemiAuto::Instance.new instances_set: [attributes] }

  describe '#name' do
    let(:name) { 'test-instance' }
    let(:attributes) do
      {
        tag_set: [
          { key: 'name', value: name }
        ]
      }
    end

    it { expect(instance.name).to eq(name) }
  end

  describe '#tags' do
    let(:attributes) do
      {
        tag_set: [
          { key: 'tag1', value: 'value1' },
          { key: 'tag2', value: 'value2' }
        ]
      }
    end

    it { expect(instance.tags).to eq({ tag1: 'value1', tag2: 'value2' }) }
  end

  describe '#instance_id' do
    let(:instance_id) { 'i-nstance' }
    let(:attributes) do
      {
        instance_id: instance_id
      }
    end

    it { expect(instance.instance_id).to eq(instance_id) }
  end

  describe '#public_dns_name' do
    let(:public_dns_name) { 'some.url.compute.amazonaws.com' }
    let(:attributes) do
      {
        dns_name: public_dns_name
      }
    end

    it { expect(instance.public_dns_name).to eq(public_dns_name) }
  end

  describe '#refresh_status' do
    let(:status) do
      {
        instance_statuses_set: [
          {
            system_status: {
              status: 'ok'
            },
            instance_status: {
              status: 'ok',
              name: 'running'
            }
          }
        ]
      }
    end

    let(:stub_ec2_instance) { double(describe_instance_status: status) }

    before do
      SemiAuto::Util.stub(:convert_to_native_types) { |arg| arg }
      SemiAuto.stub(:ec2_instance) { stub_ec2_instance }
    end

    it { expect(instance.status).to be_nil }

    context 'when it is refreshed' do
      before { instance.refresh_status }

      it { expect(instance.status).to eq(status[:instance_statuses_set].first) }
    end
  end

  describe '#refresh_description' do
    let(:name) { 'test-instance' }
    let(:new_attributes) do
      {
        tag_set: [
          { key: 'name', value: name }
        ]
      }
    end

    let(:stub_ec2_instance) { double(describe_instances: { reservations: [{ instances: [new_attributes] }] }) }

    before do
      SemiAuto::Util.stub(:convert_to_native_types) { |arg| arg }
      SemiAuto.stub(:ec2_instance) { stub_ec2_instance }
    end

    it { expect(instance.name).to be_nil }

    context 'when it is refreshed' do
      before { instance.refresh_description }

      it { expect(instance.name).to eq(name) }
    end
  end

  describe '#priority' do
    let(:name) { 'test-instance0123' }
    let(:attributes) do
      {
        tag_set: [
          { key: 'name', value: name }
        ]
      }
    end

    it { expect(instance.priority).to eq(123) }
  end
end
