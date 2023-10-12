# frozen_string_literal: true

FactoryBot.define do
  factory :client_invoice, class: 'Client::Invoice' do
    association :client, factory: :client
    description { Faker::Lorem.sentence }
    payment_type { %w[credit_card debit_card ticket].sample }
    reference_date { Faker::Date.between(from: 1.year.ago, to: Time.now.in_time_zone) }
    status { %i[generating generated error payed late].sample }
    payed_date { Faker::Date.between(from: reference_date, to: Time.now.in_time_zone) }
    invoice_value { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    max_retries { Faker::Number.between(from: 1, to: 10) }
  end
end
