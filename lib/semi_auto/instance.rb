module SemiAuto
  # Public: Model class for EC2 instances.
  class Instance
    attr_reader :attributes
    attr_accessor :status

    def initialize(attributes = {})
      @attributes = attributes[:instances_set].first
    end

    def name
      tags[:name]
    end

    def tags
      @tags ||= @attributes[:tag_set].inject({}) do |result, key_and_value|
        result.merge(key_and_value[:key].to_s.downcase.to_sym => key_and_value[:value])
      end
    end

    def instance_id
      @attributes[:instance_id]
    end

    def public_dns_name
      @attributes[:dns_name]
    end

    def state
      @status[:instance_state]
    end

    def state_string
      state[:name]
    end

    def stopped?
      state_string == 'stopped'
    end

    def running?
      state_string == 'running'
    end

    def ready?
      @status[:system_status][:status] == 'ok' &&
        @status[:instance_status][:status] == 'ok'
    end

    def start
      SemiAuto.logger.info("Starting instance #{instance_id} - #{name}")
      SemiAuto.ec2_instance.start_instances(instance_ids: [instance_id])
    end

    def stop
      SemiAuto.logger.info("Stopping instance #{instance_id} - #{name}")
      SemiAuto.ec2_instance.stop_instances(instance_ids: [instance_id])
      SemiAuto.logger.info("Stopped instance #{instance_id} - #{name}")
    end

    def refresh_status
      response = SemiAuto.ec2_instance.describe_instance_status(instance_ids: [instance_id], include_all_instances: true)

      self.status = response[:instance_status_set].first
    end

    def refresh_description
      response = SemiAuto.ec2_instance.describe_instances(instance_ids: [instance_id])

      @attributes = response[:reservation_set].first[:instances_set].first
    end

    def priority
      name.scan(/\d+/).map(&:to_i).first
    end
  end
end
