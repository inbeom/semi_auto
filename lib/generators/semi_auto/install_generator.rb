require 'rails/generators'

module SemiAuto
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_templates
        copy_file 'semi_auto.rb.erb', 'config/deploy/semi_auto.rb.erb'
        copy_file 'semi_auto.yml', 'config/semi_auto.yml'
      end
    end
  end
end
