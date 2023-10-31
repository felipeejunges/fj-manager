# frozen_string_literal: true

RSpec.describe 'Edit and Update Role', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password:, password_confirmation: password) }
  let(:role) { create(:role) }

  before do
    login(user.email, password)
    visit clients_path
    visit edit_role_path(role)
  end

  it 'allows editing role details' do
    expect(page).to have_content("Editing #{role.name}")

    fill_in 'Name', with: 'Updated Name'
    click_button 'Save'

    expect(page).to have_content('Role was successfully updated.')
    expect(page).to have_field('Name', with: 'Updated Name')
  end

  it 'does not allow editing role details with invalid data' do
    fill_in 'Code', with: ''
    click_button 'Save'

    expect(page).to have_content('Role not updated')
    expect(page).to have_content("Editing #{role.name}")
  end
end
