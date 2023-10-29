# frozen_string_literal: true

class ChartPolicy < ApplicationPolicy
  attr_reader :user, :record, :key

  def initialize(user, record)
    @user = user
    @record = record
    @key = :charts
  end
end
