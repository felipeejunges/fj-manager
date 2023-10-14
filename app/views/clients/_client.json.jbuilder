# frozen_string_literal: true

json.extract! client, :id, :name, :document, :document_type, :payment_type, :payment_day, :plan_price, :created_at, :updated_at
json.url client_url(client, format: :json)
