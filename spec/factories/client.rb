# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    association :plan, factory: :client_plan
    association :created_by, factory: :user
    name { Faker::Company.name }
    document { Faker::IDNumber.unique.brazilian_citizen_number }
    document_type { Client.document_types.keys.sample }
    payment_type { %w[credit_card debit_card ticket].sample }
    payment_day { Faker::Number.between(from: 1, to: 31) }
    discount { Faker::Number.between(from: 1, to: 10) }
    email { Faker::Internet.email }
  end
end
