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
#  start_date      :datetime         default(Sat, 14 Oct 2023 16:03:47.014772000 -03 -03:00)
#  end_date        :datetime
#  billable_period :integer          default(0)
#  max_discount    :float            default(100.0)
#  commissionable  :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
