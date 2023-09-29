# frozen_string_literal: true

json.array! @invoices, partial: 'client/invoices/invoice', as: :client_invoice
