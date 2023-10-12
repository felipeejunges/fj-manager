# frozen_string_literal: true

class Client::Invoice::ErrorLog
  include Mongoid::Document
  include Mongoid::Timestamps

  field :client_invoice_id, type: Integer
  field :date, type: DateTime
  field :log, type: String
  field :retry_number, type: Integer

  def invoice
    Client::Invoice.find(client_invoice_id)
  end

  def client
    invoice.client
  end
end
