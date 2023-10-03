# frozen_string_literal: true

class Client::Invoice < ApplicationRecord
  belongs_to :client
  has_many :error_logs, class_name: 'Client::Invoice::ErrorLog', foreign_key: :client_invoice_id, inverse_of: :invoice

  enum status: {
    generating: 0,
    generated: 1,
    error: 2,
    payed: 3,
    late: 4
  }, _default: 'generating'
end
