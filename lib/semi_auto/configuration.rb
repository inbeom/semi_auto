require 'yaml'

module SemiAuto
  class Configuration
    attr_reader :access_key_id
    attr_reader :secret_access_key
    attr_reader :region
    attr_reader :load_balancer_name
    attr_reader :prefix
    attr_reader :configurations

    def initialize(options = {})
      @file_path = options[:config_file_path]
    end

    def read
      @configurations = YAML.load(file.read) if file

      load_with_defaults
    end

    def load_with_defaults
      @access_key_id = @configurations[:access_key_id] || ENV['AWS_ACCESS_KEY_ID']
      @secret_access_key = @configurations[:secret_access_key] || ENV['AWS_SECRET_ACCESS_KEY']
      @region = @configurations[:region] || ENV['AWS_REGION']
      @load_balancer_name = @configurations[:load_balancer_name]
      @prefix = @configurations[:prefix]
    end

    def file
      if @file_path
        @file ||= File.open(@file_path, 'r')
      end
    end
  end
end
