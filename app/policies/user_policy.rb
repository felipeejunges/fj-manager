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

  def edit?
    update?
  end

  def destroy?
    user.permissions.where(key:, action: :delete).any? && user != record
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
