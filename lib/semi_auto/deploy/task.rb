require 'semi_auto/deploy/stage'

module SemiAuto
  module Deploy
    class Task
      class Failed < StandardError; end

      def initialize(options = {})
        @environment = options[:environment] || 'semi_auto'
        @task = options[:task] || 'deploy'
      end

      def stage
        SemiAuto::Deploy::Stage.new(file_path: "config/deploy/#{@environment}.rb.erb")
      end

      def bootstrap(instance)
        SemiAuto.logger.info("Starting bootstrapping #{instance.name}...")

        stage.generate_stage_file_with(instance)
        system("bundle exec cap #{@environment} deploy:bootstrap") || raise(Failed.new)

        SemiAuto.logger.info("Finished bootstrapping #{instance.name}.")
      end

      def execute(instance)
        SemiAuto.logger.info("Starting executing #{@task} task to #{instance.name}...")

        stage.generate_stage_file_with(instance)
        system("bundle exec cap #{@environment} #{@task}") || raise(Failed.new)

        SemiAuto.logger.info("Finished executing #{@task} task to #{instance.name}.")
      end
    end
  end
end
