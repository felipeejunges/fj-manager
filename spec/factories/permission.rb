# frozen_string_literal: true

FactoryBot.define do
  factory :permission do
    key { Faker::Lorem.word }
    action { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
  end
end
