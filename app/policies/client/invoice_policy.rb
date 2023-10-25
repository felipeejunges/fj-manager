# frozen_string_literal: true

class Client::InvoicePolicy < ApplicationPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :client_invoices
  end
end
