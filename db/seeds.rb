# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

u = User.find_or_create_by(first_name: 'Master', last_name: 'Admin', email: 'master@admin.com', admin: true)
u.password = '123'
u.save

p1 = Client::Plan.new(name: 'Example', description: Faker::Lorem.sentence, billable_period: 1, price: 49.90, max_discount: 20)

p1.save

p2 = Client::Plan.new(name: '2nd Second', description: Faker::Lorem.sentence, billable_period: 2, price: 29.90)

p2.save

c1 = Client.find_or_create_by(name: 'The Client', document: '12345678901', document_type: 2, payment_type: 'credit_card',
                              payment_day: 7, client_plan_id: p1.id, discount: 10)

c1.save

i1 = c1.invoices.find_or_create_by(description: 'Seed generated #1', payment_type: 'credit_card', reference_date: '2023-09-07',
                                   invoice_value: 39.90, status: 3, client_plan_id: c1.plan.id)

i1.payed_date = '2023-09-07'
i1.save

33.times do |i|
  e = i1.error_logs.find_or_create_by(retry_number: i + 1, log: Faker::Lorem.sentence)
  e.date = Time.new('2023-09-07')

  e.save
end

yesterday = Date.current.yesterday
50.times do
  client = Client.create(
    name: Faker::Company.name,
    document: Faker::IDNumber.unique.brazilian_citizen_number,
    document_type: :cpf,
    payment_type: %w[credit_card debit_card ticket].sample,
    payment_day: yesterday.day,
    client_plan_id: p1.id
  )
  client.invoices.create(
    description: Faker::Lorem.sentence,
    status: :payed,
    payed_date: yesterday,
    reference_date: yesterday,
    invoice_value: client.plan_price,
    payment_type: client.payment_type,
    client_plan_id: client.plan.id
  )
end
