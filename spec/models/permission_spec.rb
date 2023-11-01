# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permission, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:key) }
    it { should validate_presence_of(:action) }
  end
end

# == Schema Information
#
# Table name: permissions
#
#  id          :integer          not null, primary key
#  key         :string
#  action      :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
