# frozen_string_literal: true

json.array! @client_invoice_error_logs, partial: 'client/invoice/error_logs/error_log', as: :error_log
