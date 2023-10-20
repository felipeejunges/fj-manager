# frozen_string_literal: true

class Client::Invoice::ErrorLog
  include Mongoid::Document
  include Mongoid::Timestamps

  field :client_invoice_id, type: Integer
  field :date, type: DateTime
  field :log, type: String
  field :retry_number, type: Integer
  field :payment_type, type: String

  scope :range_year, ->(date) { where(date: date.beginning_of_year..date.end_of_year) }
  scope :range_month, ->(date) { where(date: date.beginning_of_month..date.end_of_month) }

  def invoice
    @invoice ||= Client::Invoice.find(client_invoice_id)
  end

  def client
    invoice.client
  end
end
