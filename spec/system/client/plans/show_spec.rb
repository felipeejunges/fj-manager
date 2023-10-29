# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Client Plans Show Page', type: :system do
  let(:password) { '123' }
  let(:admin_user) { create(:user, :admin, password:, password_confirmation: password) }
  let(:client_plan) { create(:client_plan, name: 'Sample Plan') }

  it 'displays client plan details' do
    login(admin_user.email, password)
    visit clients_path
    visit client_plan_path(client_plan)
    expect(page).to have_content('Sample Plan')
  end
end
