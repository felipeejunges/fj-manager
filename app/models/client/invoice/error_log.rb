# frozen_string_literal: true

class Client::Invoice::ErrorLog < ApplicationRecord
  belongs_to :invoice, class_name: 'Client::Invoice', foreign_key: :client_invoice_id
  has_one :client, through: :invoice
end
