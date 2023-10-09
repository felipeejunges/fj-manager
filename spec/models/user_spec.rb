require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'associations' do
    it { should have_secure_password }
  end

  describe 'callbacks' do
    let(:user) { create(:user, admin: true) }

    it 'prevents destroying the last admin user' do
      expect { user.destroy }.to change(User, :count).by(0)
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }

    it 'returns full name' do
      expect(user.name).to eq("#{user.first_name} #{user.last_name}")
    end

    it 'checks if user is an admin' do
      expect(user.admin?).to be_falsey
      admin_user = create(:user, admin: true)
      expect(admin_user.admin?).to be_truthy
    end
  end
end