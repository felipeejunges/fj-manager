# frozen_string_literal: true

json.extract! error_log, :id, :client_invoice_id, :retry_number, :date, :log, :created_at, :updated_at
json.url client_invoice_error_log_url(error_log, format: :json)
