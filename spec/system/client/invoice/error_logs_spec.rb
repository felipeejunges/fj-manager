require 'rails_helper'

RSpec.feature 'Error Logs Page', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password: password) }
  let(:client) { create(:client) }
  let(:invoice) { create(:client_invoice, client:) }
  let(:error_log) { create(:client_invoice_error_log, client_invoice_id: invoice.id) }

  it 'User views error log details' do
    login(user.email, password)
    visit clients_path
    visit client_invoice_error_log_path(client, invoice, error_log)
    expect(page).to have_content(error_log.log)
  end
end
