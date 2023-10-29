# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create User', type: :system do
  let(:admin_user) { create(:user, :admin) }

  before do
    login(admin_user.email, '123')
    visit clients_path
    visit new_user_path
  end

  it 'allows creating a new user' do
    expect(page).to have_content('New user')

    fill_in 'First name', with: 'New'
    fill_in 'Last name', with: 'User'
    fill_in 'Email', with: 'new_user@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Save'

    expect(page).to have_content('User was successfully created.')
    expect(page).to have_field('Email', with: 'new_user@example.com')
  end

  it 'does not allow creating a user with invalid data' do
    fill_in 'Email', with: admin_user.email
    click_button 'Save'

    expect(page).to have_content('User not created')
    expect(page).to have_content('New user')
  end
end
