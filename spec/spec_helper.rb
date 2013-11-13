require 'rubygems'
require 'bundler/setup'
require 'factory_girl'

$:.unshift(File.join(File.dirname(__FILE__), '../lib'))
require 'semi_auto'

Dir['./lib/semi_auto/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    SemiAuto.logger = Logger.new('/dev/null')
  end
end

FactoryGirl.find_definitions
