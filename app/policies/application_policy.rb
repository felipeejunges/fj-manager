# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
    @key = nil
  end

  def index?
    user.permissions.where(key:, action: :read).any?
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
      @key = nil
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
