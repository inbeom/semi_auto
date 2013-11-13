module SemiAuto
  class Runner
    TASKS = { up: 'up', down: 'down', match: 'match' }

    def initialize(options = {})
      options[:config_file_path] ||= 'config/semi_auto.yml'

      @configuration = SemiAuto::Configuration.new(options)
      @task = options[:task].shift
      @task_options = options[:task]
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
      when TASKS[:match]
        match_task
      end

      SemiAuto.logger.info "Current running instances - #{service.pool.running_instances.map(&:name).join(', ')}"
    end

    def match_task
      target = @task_options.first.to_i

      if service.pool.running_instances.count == target
        SemiAuto.logger.info 'Nothing to do further'
      elsif service.pool.running_instances.count < target
        SemiAuto.logger.info 'Scaling up...'
        service.scale_up
        match_task
      else
        SemiAuto.logger.info 'Scaling down...'
        service.scale_down
        match_task
      end
    end
  end
end
