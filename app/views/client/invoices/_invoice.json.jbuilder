# frozen_string_literal: true

json.extract! invoice, :id, :name, :payment_type, :reference_month, :payment_day, :status, :payed_date, :invoice_value, :had_error, :retries,
              :client_id, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
