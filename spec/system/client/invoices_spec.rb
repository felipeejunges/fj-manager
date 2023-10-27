# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Invoice Page', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password:, password_confirmation: password) }
  let(:client) { create(:client) }
  let(:invoice) { create(:client_invoice, client:, invoice_value: 100) }
  let!(:error_log) { create(:client_invoice_error_log, client_invoice_id: invoice.id) }

  it 'displays invoice details' do
    login(user.email, password)
    visit clients_path

    visit client_invoice_path(client.id, invoice)
    expect(page).to have_content('Incoming')
    expect(page).to have_content('$100.00')
    within('table tbody') do |tbody|
      expect(tbody.all('tr').count).to be > 0
    end
  end
end
