require 'semi_auto/load_balancer'
require 'semi_auto/pool'
require 'semi_auto/deploy/task'

module SemiAuto
  class Service
    attr_reader :load_balancer_name
    attr_reader :load_balancer
    attr_reader :pool

    def self.new_with_configuration(configuration)
      new(load_balancer_name: configuration.load_balancer_name, prefix: configuration.prefix)
    end

    def initialize(options = {})
      @load_balancer_name = options[:load_balancer_name]
      @pool = SemiAuto::Pool.new prefix: options[:prefix]
    end

    def bootstrap
      @pool.fetch_instances
      @pool.fetch_instance_status
      fetch_load_balancer
    end

    def fetch_load_balancer
      response = SemiAuto::Util.convert_to_native_types(SemiAuto.elb_instance.describe_load_balancers)

      @load_balancer = response[:load_balancer_descriptions].map do |load_balancer_description|
        SemiAuto::LoadBalancer.new(load_balancer_description)
      end.detect { |load_balancer| load_balancer.name == @load_balancer_name }
    end

    def scale_up
      instance = @pool.scale_up

      SemiAuto.logger.info("Instance #{instance.name} is ready! Starting processes...")

      SemiAuto::Deploy::Task.new.tap do |task|
        task.bootstrap(instance) && task.execute(instance) && @load_balancer.register(instance)
      end
    end

    def scale_down
      instance = @pool.instance_with_least_priority

      @load_balancer.deregister(instance)

      SemiAuto.logger.info('Waiting 30 seconds to wait requests to be processed...')
      sleep 30

      @pool.stop(instance)
    end
  end
end
