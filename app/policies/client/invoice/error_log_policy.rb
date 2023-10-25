# frozen_string_literal: true

class Client::Invoice::ErrorLogPolicy < ApplicationPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :client_invoice_error_logs
  end
end
