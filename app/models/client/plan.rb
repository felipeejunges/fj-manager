# frozen_string_literal: true

class Client::Plan < ApplicationRecord
  has_many :clients, class_name: 'Client', inverse_of: :plan, dependent: :destroy, foreign_key: :client_plan_id
  has_many :invoices, class_name: 'Client', inverse_of: :plan, dependent: :destroy, foreign_key: :client_plan_id

  enum billable_period: {
    never: 0,
    monthly: 1,
    three_months: 3,
    six_months: 6,
    yearly: 12
  }, _default: 'never'
end

# == Schema Information
#
# Table name: client_plans
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :string
#  price           :float            default(0.0)
#  signable        :boolean          default(TRUE)
#  sale            :boolean          default(FALSE)
#  code            :string
#  start_date      :datetime
#  end_date        :datetime
#  billable_period :integer          default("never")
#  max_discount    :float            default(100.0)
#  commissionable  :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
