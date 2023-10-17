# frozen_string_literal: true

FactoryBot.define do
  factory :client_plan, class: 'Client::Plan' do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    code { Faker::Lorem.sentence }
    start_date { Faker::Date.between(from: 1.year.ago, to: Time.now.in_time_zone) }
    commissionable { [true, false].sample }
    signable { [true, false].sample }
    sale { [true, false].sample }
    billable_period { :monthly }
    max_discount { Faker::Number.between(from: 11, to: 25) }
  end
end
