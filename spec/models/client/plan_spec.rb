# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client::Plan, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:max_discount) }
  end

  describe 'associations' do
    it { should have_many(:clients).with_foreign_key(:client_plan_id).dependent(:destroy) }
    it { should have_many(:invoices).with_foreign_key(:client_plan_id).dependent(:destroy) }
  end
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
