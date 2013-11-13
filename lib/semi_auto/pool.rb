require 'semi_auto/instance'

module SemiAuto
  # Public: Instance pool for specific service.
  class Pool
    attr_accessor :instances
    attr_accessor :prefix

    def initialize(options = {})
      @prefix = options[:prefix] || ''
    end

    def bootstrap
      fetch_instances
      fetch_instance_status
    end

    def fetch_instances
      response = SemiAuto.ec2_instance.describe_instances

      SemiAuto.logger.info "Fetching instances... with prefix #{@prefix}"

      @instances = response[:reservation_set].map { |instance| SemiAuto::Instance.new(instance) }.select { |instance| instance.name.start_with?(prefix) }.sort_by(&:priority)
    end

    def fetch_instance_status
      response = SemiAuto.ec2_instance.describe_instance_status(instance_ids: @instances.map(&:instance_id), include_all_instances: true)

      response[:instance_status_set].each do |status|
        instance_by_instance_id(status[:instance_id]).status = status
      end
    end

    def instance_by_instance_id(id)
      @instances.detect { |instance| instance.instance_id == id }
    end

    def scale_up
      instance = @instances.select(&:stopped?).sort_by(&:priority).first
      instance.start

      until instance.ready? do
        instance.refresh_status
        sleep 1
      end

      instance.refresh_description
      instance
    end

    def stop(instance)
      instance.stop

      until instance.stopped? do
        instance.refresh_status
        sleep 1
      end

      instance.refresh_description
    end

    def instance_with_least_priority
      fetch_instance_status
      running_instances.sort_by(&:priority).last
    end

    def running_instances
      @instances.select(&:running?)
    end
  end
end
