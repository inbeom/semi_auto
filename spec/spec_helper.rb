require 'rubygems'
require 'bundler/setup'
require 'factory_girl'
# require 'semi-auto'

Dir['./lib/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    SemiAuto.logger = Logger.new('/dev/null')
  end
end

FactoryGirl.find_definitions
