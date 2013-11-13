require 'semi_auto/deploy/stage'

module SemiAuto
  module Deploy
    class Task
      def initialize(options = {})
        @stage = SemiAuto::Deploy::Stage.new(file_path: 'config/deploy/new.rb.erb')
        @task = options[:task] || 'deploy'
      end

      def bootstrap(instance)
        SemiAuto.logger.info("Starting bootstrapping #{instance.name}...")

        @stage.generate_stage_file_with(instance)
        system('bundle exec cap new deploy:bootstrap')

        SemiAuto.logger.info("Finished bootstrapping #{instance.name}.")
      end

      def execute(instance)
        SemiAuto.logger.info("Starting executing #{@task} task to #{instance.name}...")

        system("bundle exec cap new #{@task}")

        SemiAuto.logger.info("Finished executing #{@task} task to #{instance.name}.")
      end
    end
  end
end
