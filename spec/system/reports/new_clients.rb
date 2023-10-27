# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'New Clients Report Page', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password:, password_confirmation: password) }
  let!(:client) { create(:client, created_at: Date.current) }

  it 'displays new clients' do
    login(user.email, password)
    visit clients_path
    visit reports_new_clients_path

    expect(page).to have_content('New clients report')
    expect(page).to have_content(client.name)
  end
end
