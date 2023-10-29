# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :users
  end

  def update?
    user.permissions.where(key:, action: :update).any? || user == record
  end

  def apply_role?
    user.permissions.where(key:, action: :update).any?
  end

  def destroy?
    user.permissions.where(key:, action: :delete).any? && user != record
  end
end
