# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'semi_auto/version'

Gem::Specification.new do |spec|
  spec.name          = "semi_auto"
  spec.version       = SemiAuto::VERSION
  spec.authors       = ['Inbeom Hwang']
  spec.email         = ['hwanginbeom@gmail.com']
  spec.description   = 'Scale up/down your AWS instances on your own locally without Auto Scaling'
  spec.summary       = 'Semi-automatic scaling of applications on AWS without Auto Scaling'
  spec.homepage      = 'https://github.com/inbeom/semi_auto'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk'
  spec.add_dependency 'capistrano', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'factory_girl'
end
