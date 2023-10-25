# frozen_string_literal: true

class ReportPolicy < ApplicationPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :reports
  end

  def new_clients?
    index?
  end

  def clients_invoiced_yesterday?
    index?
  end

  def clients_invoiced_today?
    index?
  end

  def clients?
    index?
  end
end
