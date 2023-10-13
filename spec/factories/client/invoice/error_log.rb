# frozen_string_literal: true

FactoryBot.define do
  factory :client_invoice_error_log, class: 'Client::Invoice::ErrorLog' do
    retry_number { Faker::Number.between(from: 1, to: 10) }
    date { Faker::Time.between(from: 1.year.ago, to: Time.now.in_time_zone) }
    log { Faker::Lorem.sentence }

    client_invoice_id { Client::Invoice.first&.id || create(:client_invoice)&.id }
  end
end
