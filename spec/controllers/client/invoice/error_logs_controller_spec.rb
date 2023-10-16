# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client::Invoice::ErrorLogsController, type: :controller do
  let(:user) { create(:user) }
  let(:client) { create(:client) }
  let(:invoice) { create(:client_invoice, client:) }
  let(:error_log) { create(:client_invoice_error_log, client_invoice_id: invoice.id) }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { client_id: client.id, invoice_id: invoice.id, id: error_log.id }
      expect(response).to be_successful
    end
  end
end
