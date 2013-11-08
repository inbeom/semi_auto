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
  spec.summary       = 'Semi-automatic scaling for web applications deployed on AWS with Capistrano'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk-core', '~> 2.0.0.rc1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
