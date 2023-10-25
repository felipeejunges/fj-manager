# frozen_string_literal: true

class RolePolicy < ApplicationPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :roles
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
