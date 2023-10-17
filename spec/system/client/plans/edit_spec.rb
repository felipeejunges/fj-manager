# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Client Plans Edit Page', type: :system do
  let(:password) { '123' }
  let(:admin_user) { create(:user, :admin, password:) }
  let(:client_plan) { create(:client_plan, name: 'Sample Plan') }

  before do
    login(admin_user.email, admin_user.password)
    visit clients_path
    visit edit_client_plan_path(client_plan)
  end

  it 'allows admin to edit the client plan with valid data' do
    fill_in 'Name', with: 'Updated Plan Name'
    fill_in 'Description', with: 'Updated Plan Description'
    fill_in 'Price', with: 199.99
    check 'Sale'
    uncheck 'Commissionable'
    click_button 'Save'

    expect(page).to have_field('Name', with: 'Updated Plan Name')
    expect(page).to have_field('Description', with: 'Updated Plan Description')
    expect(page).to have_content('Plan was successfully updated.')
  end

  it 'displays error message with invalid data' do
    fill_in 'Price', with: ''
    click_button 'Save'

    expect(page).to have_content("Price can't be blank")
    expect(page).to have_content("Editing #{client_plan.name}")
  end
end
