require 'factory_girl'

FactoryGirl.define do
  factory :instance, class: SemiAuto::Instance do
    skip_create

    ignore do
      sequence(:name) { |n| "instance-#{n}" }
      instance_id { "id#{name}" }
      public_dns_name { "#{name}.compute.amazonaws.com" }
      tags { [{ key: 'name', value: name }] }
      state { 'running' }
      system_status { state == 'running' ? 'ok' : '' }
      instance_status { state == 'running' ? 'ok' : '' }

      attributes_hash do
        {
          instance_id: instance_id,
          public_dns_name: public_dns_name,
          tags: tags
        }
      end

      status_hash do
        {
          instance_state: {
            code: 16,
            name: state
          },
          instance_status: {
            status: instance_status
          },
          system_status: {
            status: system_status
          }
        }
      end
    end

    status { status_hash }

    initialize_with do
      new(instances: [attributes_hash])
    end
  end

  factory :pool, class: SemiAuto::Pool do
    skip_create
  end
end
