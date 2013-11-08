require 'semi_auto/deploy/stage'

module SemiAuto
  module Deploy
    class Task
      def initialize
        @stage = SemiAuto::Deploy::Stage.new(file_path: 'config/deploy/new.rb.erb')
      end

      def bootstrap(instance)
        SemiAuto.logger.info("Starting bootstrapping #{instance.name}...")

        @stage.generate_stage_file_with(instance)
        system('bundle exec cap new deploy:bootstrap')

        SemiAuto.logger.info("Finished bootstrapping #{instance.name}.")
      end

      def execute(instance)
        SemiAuto.logger.info("Starting deploying to #{instance.name}...")

        system('bundle exec cap new deploy')

        SemiAuto.logger.info("Finished deploying to #{instance.name}.")
      end
    end
  end
end
