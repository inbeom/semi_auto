module SemiAuto
  class LoadBalancer
    def initialize(attributes = {})
      @attributes = attributes
    end

    def name
      @attributes[:load_balancer_name]
    end

    def register(instance)
      SemiAuto.logger.info("Registering #{instance.name} with load balancer #{name}...")

      SemiAuto.elb_instance.register_instances_with_load_balancer load_balancer_name: name, instances: [instance].map { |i| { instance_id: i.instance_id } }

      SemiAuto.logger.info("Registered #{instance.name} with load balancer #{name}.")
    end

    def deregister(instance)
      SemiAuto.logger.info("Deregistering #{instance.name} from load balancer #{name}...")

      SemiAuto.elb_instance.deregister_instances_from_load_balancer load_balancer_name: name, instances: [instance].map { |i| { instance_id: i.instance_id } }

      SemiAuto.logger.info("Deregistered #{instance.name} from load balancer #{name}.")
    end
  end
end
