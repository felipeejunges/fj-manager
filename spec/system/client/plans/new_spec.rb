# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Client Plans New Page', type: :system do
  let(:password) { '123' }
  let(:admin_user) { create(:user, :admin, password:) }

  before do
    login(admin_user.email, admin_user.password)
    visit clients_path
    visit new_client_plan_path
  end

  it 'allows admin to create a new client plan with valid data' do
    fill_in 'Name', with: 'New Plan'
    fill_in 'Description', with: 'Sample Description'
    fill_in 'Price', with: 99.99
    check 'Sale'
    check 'Signable'
    uncheck 'Commissionable'
    click_button 'Save'

    expect(page).to have_field('Name', with: 'New Plan')
    expect(page).to have_field('Description', with: 'Sample Description')
  end

  it 'displays error message with invalid data' do
    fill_in 'Name', with: ''
    click_button 'Save'

    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content('New plan')
  end
end
