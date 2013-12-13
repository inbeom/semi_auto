require 'logger'
require 'semi_auto/configuration'
require 'semi_auto/service'
require 'semi_auto/util'
require 'aws'

module SemiAuto
  def self.configure(configuration = nil)
    @configuration = configuration || SemiAuto::Configuration.new

    AWS.config access_key_id: @configuration.access_key_id,
      secret_access_key: @configuration.secret_access_key,
      region: @configuration.region
  end

  def self.ec2_instance
    @ec2_instance ||= AWS::EC2.new.client
  end

  def self.elb_instance
    @elb_instance ||= AWS::ELB.new.client
  end

  def self.logger
    @logger ||= Logger.new(STDOUT).tap do |logger|
      logger.level == Logger::INFO
    end
  end

  def self.logger=(logger)
    @logger = logger
  end
end
