require 'rails_helper'

RSpec.feature 'Invoice Page', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password: password) }
  let(:client) { create(:client) }
  let(:invoice) { create(:client_invoice, client: client, invoice_value: 100) }
  let!(:old_error_log) { create(:client_invoice_old_error_log, invoice: invoice) }

  it 'displays invoice details' do
    login(user.email, password)
    visit clients_path
    
    visit client_invoice_path(client.id, invoice)
    expect(page).to have_content('Incoming')
    expect(page).to have_content("$100.00")
    all("table tbody")[1] do |tbody|
      expect(tbody.all('tr').count).to be > 0
    end
  end
end