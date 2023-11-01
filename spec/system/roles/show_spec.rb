# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Show Page', type: :system do
  let(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let(:role) { create(:role) }

  before do
    login(admin_user.email)
    visit clients_path
  end

  it 'displays role details' do
    visit edit_role_path(role)
    click_link 'Show', href: role_path(role)
    expect(page).to have_field('Name', with: role.name)
  end

  it 'allows navigating back to the index page' do
    visit role_path(role)
    click_link 'Back to Roles'

    expect(page).to have_content('Roles')
  end
end
