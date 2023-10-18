# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Clients Invoiced Today Report Page', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password:) }
  let!(:clients) { create_list(:client, 5) }
  let!(:client) { clients.first }
  let!(:invoice) { create(:client_invoice, client:, reference_date: Date.current, status: :generated) }

  it 'displays clients invoiced yesterday' do
    login(user.email, password)
    visit clients_path
    visit reports_clients_invoiced_today_path

    expect(page).to have_content('Clients invoiced today report')
    expect(page).to have_content(client.name)
  end
end
