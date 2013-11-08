module SemiAuto
  class Runner
    TASKS = { up: 'up', down: 'down' }

    def initialize(options = {})
      @configuration = SemiAuto::Configuration.new(options)
      @task = options[:task]
    end

    def run
      @configuration.read
      SemiAuto.configure(@configuration)
      SemiAuto.logger.info "Prefix - #{@configuration.prefix}"
      SemiAuto.logger.info "Load balancer name - #{@configuration.load_balancer_name}"

      service.bootstrap
      perform_task
    end

    def service
      @service ||= SemiAuto::Service.new_with_configuration(@configuration)
    end

    def perform_task
      SemiAuto.logger.info "Current running instances - #{service.pool.running_instances.map(&:name).join(', ')}"
      SemiAuto.logger.info "Task: #{@task}"

      case @task
      when TASKS[:up]
        service.scale_up
      when TASKS[:down]
        service.scale_down
      end

      SemiAuto.logger.info "Current running instances - #{service.pool.running_instances.map(&:name).join(', ')}"
    end
  end
end
