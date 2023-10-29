# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client::Invoice::ErrorLogsController, type: :controller do
  let(:user) { create(:user, :admin) }
  let(:client) { create(:client) }
  let(:invoice) { create(:client_invoice, client:) }
  let(:error_log) { create(:client_invoice_error_log, client_invoice_id: invoice.id) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { client_id: client.id, invoice_id: invoice.id, id: error_log.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #index' do
    let!(:error_logs) { create_list(:client_invoice_error_log, 3, client_invoice_id: invoice.id) }
    it 'renders the index template' do
      get :index, params: { client_id: client.id, invoice_id: invoice.id }
      expect(response).to render_template('client/invoice/error_logs/_table')
      expect(response).to have_http_status(:ok)
    end

    it 'ordered correctly' do
      get :index, params: { client_id: client.id, invoice_id: invoice.id, sort_by: 'id', sort_order: 'DESC' }
      expect(assigns(:error_logs).pluck(:id)).to eq(Client::Invoice::ErrorLog.order(id: :desc).pluck(:id))
    end
  end
end
