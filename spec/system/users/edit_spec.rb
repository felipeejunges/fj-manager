# frozen_string_literal: true

RSpec.describe 'Edit and Update User', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password:, password_confirmation: password) }

  before do
    login(user.email, password)
    visit clients_path
    visit edit_user_path(user)
  end

  it 'allows editing user details' do
    expect(page).to have_content("Editing #{user.name}")

    fill_in 'Email', with: 'updated_john@email.com'
    click_button 'Save'

    expect(page).to have_content('User was successfully updated.')
    expect(page).to have_field('Email', with: 'updated_john@email.com')
  end

  it 'does not allow editing user details with invalid data' do
    fill_in 'Email', with: ''
    click_button 'Save'

    expect(page).to have_content('User not updated')
    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content("Editing #{user.name}")
  end
end
