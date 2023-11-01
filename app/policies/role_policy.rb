# frozen_string_literal: true

class RolePolicy < ApplicationPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :roles
  end

  def update?
    user.permissions.where(key:, action: :update).any? && record.editable == true
  end

  def edit?
    user.permissions.where(key:, action: :update).any?
  end

  def apply_permission?
    update?
  end

  def destroy?
    user.permissions.where(key:, action: :delete).any? && record.deletable == true
  end
end
