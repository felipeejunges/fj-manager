# frozen_string_literal: true

class Client::PlanPolicy < ApplicationPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :client_plans
  end
end
