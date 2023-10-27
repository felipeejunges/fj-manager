# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User Sessions', type: :system do
  let(:password) { 'password' }
  let(:user) { create(:user, email: 'test@example.com', password:, password_confirmation: password) }

  scenario 'user logs in with valid credentials' do
    login(user.email, password)

    expect(page).to have_content("Welcome, #{user.name}")
  end

  scenario 'user sees error with invalid credentials' do
    login('invalid@example.com', 'wrongpassword')

    expect(page).to have_content('Invalid email or password')
  end
end
