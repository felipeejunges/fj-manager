# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Show Page', type: :system do
  let(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }

  before do
    login(admin_user.email)
    visit clients_path
  end

  it 'displays user details' do
    visit edit_user_path(user)
    click_link 'Show', href: user_path(user)
    expect(page).to have_field('Email', with: user.email)
  end

  it 'allows navigating back to the index page' do
    visit user_path(user)
    click_link 'Back to Users'

    expect(page).to have_content('Users')
  end

  it 'should apply permission' do
    visit user_path(user)
    within('table') do |table|
      tr = table.first('tr')
      tr.check 'allowed'
      expect(tr).to have_field('allowed', checked: true)
    end
  end
end
