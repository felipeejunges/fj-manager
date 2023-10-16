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
