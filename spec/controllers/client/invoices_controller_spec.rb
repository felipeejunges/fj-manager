# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client::InvoicesController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user) }
  let(:client) { create(:client) }
  let(:invoice) { create(:client_invoice, client:) }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)

    allow(::GenerateInvoiceJob).to receive(:perform_in).and_return(nil)
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { client_id: client.id, id: invoice.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #retry' do
    it 'renders show template with success message if retry succeeds' do
      patch :retry, params: { client_id: client.id, id: invoice.id, client_invoice: { payment_type: 'credit_card' } }
      expect(response).to redirect_to(client_invoice_path(client, invoice))
      expect(flash[:success]).to be_present
    end

    it 'renders show template with error message if retry fails' do
      allow_any_instance_of(Client::Invoice).to receive(:save).and_return(false)
      patch :retry, params: { client_id: client.id, id: invoice.id, client_invoice: { payment_type: 'credit_card' } }
      expect(response).to render_template(:show)
      expect(flash[:error]).to be_present
    end
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index, params: { client_id: client.id }
      expect(response).to render_template('client/invoices/_table')
      expect(response).to have_http_status(:ok)
    end
  end
end
