# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { '123' }
    password_confirmation { '123' }

    trait :admin do
      after(:create) do |user|
        admin_role = Role.find_by(code: 'admin')
        user.roles << admin_role if admin_role
      end
    end
  end
end
