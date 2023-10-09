require 'rails_helper'

RSpec.describe 'User Show Page', type: :system do
  let(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }

  before do
    login(admin_user.email, admin_user.password)
    visit clients_path
    visit edit_user_path(user)
    click_link 'Show', href: user_path(user)
  end

  it 'displays user details' do
    expect(page).to have_field('Email', with: user.email)
  end

  it 'allows navigating back to the index page' do
    click_link 'Back to Users'

    expect(page).to have_content('New User')
  end
end