# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def index?
    user.permissions.where(key:, action: :read).any?
  end

  def list?
    index?
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
