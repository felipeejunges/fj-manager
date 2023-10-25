# frozen_string_literal: true

class UserPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :users
  end

  def index?
    user.permissions.where(key:, action: :show).any?
  end

  def show?
    index?
  end

  def create?
    user.permissions.where(key:, action: :create).any?
  end

  def new?
    create?
  end

  def update?
    user.permissions.where(key:, action: :update).any?
  end

  def edit?
    update?
  end

  def destroy?
    user.permissions.where(key:, action: :delete).any?
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
