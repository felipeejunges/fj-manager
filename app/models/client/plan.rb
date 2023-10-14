# frozen_string_literal: true

class Client::Plan < ApplicationRecord
  has_many :clients, class_name: 'Client', inverse_of: :plan, dependent: :destroy

  enum status: {
    never: 0,
    monthly: 1,
    three_months: 2,
    six_months: 3,
    yearly: 4
  }, _default: 'never'
end
