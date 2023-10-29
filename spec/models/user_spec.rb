# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  # describe 'callbacks' do
  #   let(:user) { create(:user) }
  #
  #   it 'prevents destroying the last admin user' do
  #     expect { user.destroy }.to change(User, :count).by(0)
  #   end
  # end

  describe 'methods' do
    let(:user) { create(:user) }

    it 'returns full name' do
      expect(user.name).to eq("#{user.first_name} #{user.last_name}")
    end

    it 'checks if user is an admin' do
      expect(user.admin?).to be_falsey
      admin_user = create(:user, :admin)
      expect(admin_user.admin?).to be_truthy
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  first_name       :string
#  last_name        :string
#  email            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  crypted_password :string
#  salt             :string
#
