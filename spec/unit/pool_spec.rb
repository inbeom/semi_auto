require 'spec_helper'

describe SemiAuto::Pool do
  let(:prefix) { '' }
  let(:pool) { SemiAuto::Pool.new prefix: prefix }

  describe '#fetch_instances' do
    let(:instance_names) { ['test01', 'test02', 'test03', 'test04'] }
    let(:instances) { instance_names.map { |name| FactoryGirl.create(:instance, name: name) } }
    let(:response) { { reservations: instances.map { |instance| { instances: [instance.attributes] } } } }
    let(:stub_ec2_instance) { double(describe_instances: response) }

    before do
      SemiAuto::Util.stub(:convert_to_native_types) { |arg| arg }
      SemiAuto.stub(:ec2_instance) { stub_ec2_instance }
    end

    it { expect { pool.fetch_instances }.not_to raise_error }

    context 'when it is fetched' do
      before { pool.fetch_instances }

      it { expect(pool.instances.count).to eq(instances.count) }
      it { expect(pool.instances.map(&:name).sort).to eq(instance_names.sort) }

      context 'when instances are filtered by prefix' do
        let(:instance_names) { ['test01', 'test02', 'filtered03', 'test04'] }
        let(:prefix) { 'test' }
        before { pool.fetch_instances }

        it { expect(pool.instances.count).to eq(instances.count - 1) }
        it { expect(pool.instances.map(&:name).sort).to eq(instance_names.select { |n| n =~ /test/ }.sort) }
      end
    end
  end

  describe '#scale_up' do
    let(:running_instance) { FactoryGirl.create(:instance, name: 'test01') }
    let(:stopped_instance) { FactoryGirl.create(:instance, name: 'test02', state: 'stopped') }
    let(:instances) { [running_instance, stopped_instance] }
    let(:pool) { FactoryGirl.create(:pool, instances: instances) }

    before { stopped_instance.should_receive(:start) { true } }
    before { stopped_instance.should_receive(:ready?) { true } }
    before { stopped_instance.should_receive(:refresh_description) { true } }

    it { expect { pool.scale_up }.not_to raise_error }
    it { expect(pool.scale_up).to eq(stopped_instance) }
  end

  describe '#stop' do
    let(:running_instance) { FactoryGirl.create(:instance, name: 'test01') }
    let(:instances) { [running_instance] }
    let(:pool) { FactoryGirl.create(:pool, instances: instances) }

    before { running_instance.should_receive(:stop) { true } }
    before { running_instance.should_receive(:stopped?) { true } }
    before { running_instance.should_receive(:refresh_description) { true } }

    it { expect { pool.stop(running_instance) }.not_to raise_error }
  end

  describe '#instance_with_least_priority' do
    let(:instance_names) { ['test01', 'test02', 'test03', 'test04'] }
    let(:instances) { instance_names.map { |name| FactoryGirl.create(:instance, name: name) } }
    let(:pool) { FactoryGirl.create(:pool, instances: instances) }

    before { pool.stub(:fetch_instance_status) { true } }

    it { expect(pool.instance_with_least_priority).to eq(instances.last) }
  end

  describe '#running_instances' do
    let(:running_instance) { FactoryGirl.create(:instance, name: 'test01') }
    let(:stopped_instance) { FactoryGirl.create(:instance, name: 'test02', state: 'stopped') }
    let(:instances) { [running_instance, stopped_instance] }
    let(:pool) { FactoryGirl.create(:pool, instances: instances) }

    it { expect(pool.running_instances).to eq([running_instance]) }
  end
end
