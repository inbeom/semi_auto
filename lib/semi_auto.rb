require 'logger'
require 'semi_auto/configuration'
require 'semi_auto/service'
require 'semi_auto/util'

module SemiAuto
  def self.configure(configuration = nil)
    @configuration = configuration || SemiAuto::Configuration.new

    Aws.config = {
      access_key_id: @configuration.access_key_id,
      secret_access_key: @configuration.secret_access_key,
      region: @configuration.region
    }
  end

  def self.ec2_instance
    @ec2_instance ||= Aws::EC2.new
  end

  def self.elb_instance
    @elb_instance ||= Aws::ElasticLoadBalancing.new
  end

  def self.logger
    @logger ||= Logger.new(STDOUT).tap do |logger|
      logger.level == Logger::INFO
    end
  end
end
