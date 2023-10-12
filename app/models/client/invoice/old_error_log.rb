# frozen_string_literal: true

class Client::Invoice::OldErrorLog < ApplicationRecord
  belongs_to :invoice, class_name: 'Client::Invoice', foreign_key: :client_invoice_id
  has_one :client, through: :invoice

  scope :range_year, ->(date) { where(date: date.beginning_of_year..date.end_of_year) }
  scope :range_month, ->(date) { where(date: date.beginning_of_month..date.end_of_month) }
end
