# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Roles Index Page', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password:, password_confirmation: password) }
  let!(:roles) { create_list(:role, 2) }
  let!(:role) { roles.first }

  before do
    login(user.email, password)
    visit clients_path
    visit roles_path
  end

  it 'displays a list of roles' do
    expect(page).to have_content('Administrator')
    expect(page).to have_content(role.name)
  end

  it 'allows the role to view a specific role' do
    click_link role.name, href: role_path(role)
    expect(page).to have_current_path(role_path(role))
    expect(page).to have_content(role.name)
  end
end
