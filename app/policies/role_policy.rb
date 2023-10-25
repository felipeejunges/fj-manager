# frozen_string_literal: true

class RolePolicy < ApplicationPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :roles
  end
end
