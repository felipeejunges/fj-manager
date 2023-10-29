# frozen_string_literal: true

class ClientPolicy < ApplicationPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :clients
  end

  def update?
    user.permissions.where(key:, action: :update).any? || user == record.created_by
  end
end
