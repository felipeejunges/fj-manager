# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

u = User.find_or_create_by(first_name: 'Master', last_name: 'Admin', email: 'master@admin.com', admin: true)
u.save

c1 = Client.find_or_create_by(name: 'The Client', document: '12345678901', document_type: 2, payment_type: 'credit_card',
                              payment_day: 7, plan_value: 49.90)

c2 = Client.find_or_create_by(name: 'Second Client', document: '23456789012', document_type: 2, payment_type: 'debit_card',
                              payment_day: 10, plan_value: 44.90)

c1.save
c2.save

i1 = c1.invoices.find_or_create_by(description: 'Seed generated', payment_type: 'credit_card', reference_date: '2023-09-07',
                                   invoice_value: 39.90, payed_date: '2023-09-07', status: 3)

i1.save

i2 = c1.invoices.find_or_create_by(description: 'Seed generated', payment_type: 'credit_card', reference_date: '2023-08-07',
                                   invoice_value: 39.90, payed_date: '2023-08-07', status: 3)

i2.save

e = i1.error_logs.find_or_create_by(retry_number: 1, date: '2023-09-07', log: 'Example')

e.save
