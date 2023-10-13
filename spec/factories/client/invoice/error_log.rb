# frozen_string_literal: true

FactoryBot.define do
  factory :client_invoice_error_log, class: 'Client::Invoice::OldErrorLog' do
    association :invoice, factory: :client_invoice
    retry_number { Faker::Number.between(from: 1, to: 10) }
    date { Faker::Time.between(from: 1.year.ago, to: Time.now.in_time_zone) }
    log { Faker::Lorem.sentence }
  end
end
