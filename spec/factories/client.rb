# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    name { Faker::Company.name }
    document { Faker::IDNumber.unique.brazilian_citizen_number }
    document_type { Client.document_types.keys.sample }
    payment_type { %w[credit_card debit_card ticket].sample }
    payment_day { Faker::Number.between(from: 1, to: 31) }
    plan_value { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
  end
end
