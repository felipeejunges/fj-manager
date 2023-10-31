# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

def data(file_name)
  YAML.load_file(Rails.root.join("db/seeds/#{file_name}.yml"))
end

def permissions
  data('permissions').each do |category, actions|
    actions.each do |action, description|
      Permission.find_or_create_by(key: category, action:, description:)
    end
  end
end

def roles
  data('roles').each do |r|
    role = r[1]
    Role.find_or_create_by(id: role['id'], name: role['name'], code: role['code'], description: role['description'], editable: role['editable'],
                           deletable: role['deletable'])
  end
end

def roles_permissions
  data('roles_permissions').map do |roles_permissions|
    rp = roles_permissions[1]
    role = Role.find(rp['role_id'])

    rp['permissions'].map do |key, actions|
      actions.each do |action|
        role.permissions << Permission.find_by(action:, key:)
      end
    end
  end
end

def users_roles
  data('users_roles').each do |users_roles|
    ur = users_roles[1]
    user = User.find(ur['user_id'])
    ur['roles'].each do |code|
      role = Role.find_by(code:)
      user.roles << role
    end
  end
end

def users
  data('users').each do |u|
    user = User.find_or_create_by(id: u['id'], first_name: u['first_name'], last_name: u['last_name'], email: u['email'])
    user.password = '123'
    user.password_confirmation = '123'
    user.save
  end
end

users
permissions
roles
roles_permissions
users_roles

return if Rails.env.test?

u = User.first

p1 = Client::Plan.new(name: 'Example', description: Faker::Lorem.sentence, billable_period: 1, price: 49.90, max_discount: 20,
                      start_date: Time.current)

p1.save

p2 = Client::Plan.new(name: '2nd Second', description: Faker::Lorem.sentence, billable_period: 3, price: 29.90)

p2.save

c1 = Client.find_or_create_by(name: 'The Client', document: '12345678901', document_type: 2, payment_type: 'credit_card',
                              payment_day: Time.current.day, client_plan_id: p1.id, discount: 10, email: Faker::Internet.email, created_by_id: u.id)

c1.save

i1 = c1.invoices.find_or_create_by(description: 'Seed generated #1', payment_type: 'credit_card', reference_date: '2023-09-07',
                                   invoice_value: 39.90, status: 3, client_plan_id: p1.id)

i1.payed_date = '2023-09-07'
i1.save

i2 = c1.invoices.find_or_create_by(description: 'Seed generated #2', payment_type: 'credit_card', reference_date: '2022-09-07',
                                   invoice_value: 19.90, status: 3, client_plan_id: p1.id)

i2.payed_date = '2023-09-07'
i2.save
i3 = c1.invoices.find_or_create_by(description: 'Seed generated #3', payment_type: 'credit_card', reference_date: '2022-10-07',
                                   invoice_value: 339.90, status: 3, client_plan_id: p1.id)

i3.payed_date = '2023-09-07'
i3.save

33.times do |i|
  e = i1.error_logs.find_or_create_by(retry_number: i + 1, log: Faker::Lorem.sentence, payment_type: 'credit_card')
  e.date = Time.new('2023-09-07')

  e.save
end

today = Date.current
dates = [today.yesterday, today, today.last_month, today - 2.days, today,
         today.yesterday, today - 3.days, today - 4.days, today - 5.days,
         today - 6.days, today - 7.days, today, today.yesterday, today.last_month,
         today.yesterday.last_month, today.tomorrow.last_month, today, today.yesterday, today]
50.times do
  date = dates.sample
  client = Client.create(
    name: Faker::Company.name,
    document: Faker::IDNumber.unique.brazilian_citizen_number,
    document_type: :cpf,
    payment_type: %w[credit_card debit_card ticket].sample,
    payment_day: date.day,
    client_plan_id: p1.id,
    email: Faker::Internet.email,
    created_by_id: u.id
  )
  next unless date != Date.current

  client.invoices.create(
    description: Faker::Lorem.sentence,
    status: :payed,
    payed_date: date,
    reference_date: date,
    invoice_value: client.net_value,
    payment_type: client.payment_type,
    client_plan_id: client.plan.id
  )
end
