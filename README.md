Semi-auto
=========

Semi-automatic scaling for Rails (or non-Rails) applications deployed on AWS
with Capistrano without AWS Auto Scaling.

You can achieve hassle-free scaling up/down for your service without using
AWS' Auto Scaling. It provides simpler configuration than that of Auto Scaling
and is suitable for environments which Auto Scaling is not applicable without
massive environment change.

It has some conventions and requirements: read Requirements section below.

Installation
------------

Add this line to your application's Gemfile:

    gem 'semi_auto'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install c11n

Usage
-----

### For Rails applications

Generate templates for `semi_auto` using generator:

    rails g semi_auto:install

Write config file located at `config/semi_auto.yml` for your environment:

    ---
    :access_key_id: [Your AWS access key]
    :secret_access_key: [Your AWS secret access key]
    :region: [Your AWS region]
    :load_balancer_name: [ELB instance name]
    :prefix: [Common prefix for your application instances]

Customize `config/deploy/semi_auto.rb.erb`:

    role :web, '<%= public_dns_name %>'
    role :app, '<%= public_dns_name %>'
    role :db, '<%= public_dns_name %>'

Provide tasks listed below in `config/deploy.rb`:

  - `deploy:bootstrap`: Bootstrapping for your environment. (e.g. spinning up
                        nginx, etc)
  - `deploy`: Common deploy task for your application.

Scaling up:

    $ semi-auto up

Scaling down:

    $ semi-auto down

Match number of instances to specified number:

    $ semi-auto match 2

### For non-Rails applications

Write your configuration file and stage template. Stage template should be
located at `config/deploy/semi_auto.rb.erb`.

When running `semi_auto`, provide path of configuration file unless it is
located at `config/semi_auto.yml`:

    $ semi-auto -c [PATH TO CONFIG FILE] up

Requirements
------------

  - Designed to work with single ELB instance and multiple EC2 application
    instances under it.
  - Your application instances should have same prefix. Tags will be supported
    in future.
  - Will not work properly without bundler.
  - Current working directory should be project root.
