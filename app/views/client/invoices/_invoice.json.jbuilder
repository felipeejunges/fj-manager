# frozen_string_literal: true

json.extract! invoice, :id, :description, :payment_type, :reference_date, :payment_day, :status, :payed_date, :invoice_value,
              :client_id, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
