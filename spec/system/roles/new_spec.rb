# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create User', type: :system do
  let(:admin_user) { create(:user, :admin) }

  before do
    login(admin_user.email, '123')
    visit clients_path
    visit new_role_path
  end

  it 'allows creating a new role' do
    expect(page).to have_content('New role')

    fill_in 'Name', with: 'New Name'
    fill_in 'Code', with: 'Code'
    click_button 'Save'

    expect(page).to have_content('Role was successfully created.')
    expect(page).to have_field('Name', with: 'New Name')
  end

  it 'does not allow creating a role with invalid data' do
    fill_in 'Name', with: 'Updated Name'
    click_button 'Save'

    expect(page).to have_content('Role not created')
    expect(page).to have_content('New role')
  end
end
