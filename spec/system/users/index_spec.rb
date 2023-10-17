# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users Index Page', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password:) }
  let!(:user1) { create(:user, first_name: 'John', last_name: 'Doe', email: 'john@example.com') }
  let!(:user2) { create(:user, first_name: 'Jane', last_name: 'Smith', email: 'jane@example.com') }

  before do
    login(user.email, password)
    visit clients_path
    visit users_path
  end

  it 'displays a list of users' do
    expect(page).to have_content('Users')
    expect(page).to have_content('John Doe')
    expect(page).to have_content('Jane Smith')
  end

  it 'allows the user to view a specific user' do
    click_link user1.name, href: user_path(user1)
    expect(page).to have_current_path(user_path(user1))
    expect(page).to have_content('John Doe')
  end
end
