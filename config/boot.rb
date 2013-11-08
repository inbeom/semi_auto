$:.unshift(File.join(File.dirname(__FILE__), '../lib'))
ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.setup
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require 'semi_auto'
