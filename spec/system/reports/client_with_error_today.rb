# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Clients With Error Today Report Page', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password:) }
  let!(:clients) { create_list(:client, 5) }
  let!(:client) { clients.first }
  let!(:invoice) { create(:client_invoice, client:, reference_date: Date.current, status: :error) }

  it 'displays clients invoiced yesterday' do
    login(user.email, password)
    visit clients_path
    visit reports_clients_with_error_today_path

    expect(page).to have_content('Clients with error today report')
    expect(page).to have_content(client.name)
  end
end
