# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    code { Faker::Lorem.word }
    active { true }
    deletable { true }
    editable { true }
  end
end
