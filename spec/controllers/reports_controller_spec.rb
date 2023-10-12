require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #new_clients' do
    it 'assigns all clients to @clients' do
      clients = create_list(:client, 3, created_at: Date.current)
      get :new_clients
      expect(assigns(:clients)).to match_array(clients)
    end

    it 'filters clients based on payment type and date range' do
      client_with_payment_type = create(:client, payment_type: 'credit_card')
      client_without_payment_type = create(:client, payment_type: 'bank_transfer')
      get :new_clients, params: { payment_type: 'credit_card', start_date: Date.current, end_date: Date.tomorrow }
      expect(assigns(:clients)).to match_array([client_with_payment_type])
    end

    it 'renders the new_clients template' do
      get :new_clients
      expect(response).to render_template(:new_clients)
    end
  end

  describe 'GET #clients_invoiced_yesterday' do
    it 'assigns clients with invoices from yesterday to @clients' do
      client = create(:client)
      invoice = create(:client_invoice, client:, reference_date: Date.current.yesterday, invoice_value: 100, status: :generated)
      get :clients_invoiced_yesterday

      expect(assigns(:clients)).to match_array([client])
    end

    it 'filters clients based on payment type and document type' do
      client_with_payment_type = create(:client, payment_type: 'credit_card', document_type: 'cnpj')
      create(:client_invoice, client: client_with_payment_type, invoice_value: 1000, reference_date: Date.current.yesterday, status: :payed)
      client_without_payment_type = create(:client, payment_type: 'bank_transfer', document_type: 'cpf')

      get :clients_invoiced_yesterday, params: { payment_type: 'credit_card', document_type: 'cnpj' }
      expect(assigns(:clients)).to match_array([client_with_payment_type])
    end

    it 'renders the clients_invoiced_yesterday template' do
      get :clients_invoiced_yesterday
      expect(response).to render_template(:clients_invoiced_yesterday)
    end
  end

  describe 'GET #clients' do
    it 'assigns all clients to @clients' do
      clients = create_list(:client, 3)
      get :clients
      expect(assigns(:clients).map(&:name)).to match_array(clients.map(&:name))
    end

    it 'filters clients based on payment type, status, and document type' do
      client_with_options = create(:client, payment_type: 'credit_card', document_type: 'cnpj')
      create(:client_invoice, client: client_with_options, invoice_value: 1000, reference_date: Date.current, status: :generated)
      client_without_options = create(:client, payment_type: 'bank_transfer', document_type: 'cpf')
      create(:client_invoice, client: client_without_options, invoice_value: 1000, reference_date: Date.current, status: :error)
      
      get :clients, params: { payment_type: 'credit_card', status: 'generated', document_type: 'cnpj' }

      expect(assigns(:clients)).to match_array([client_with_options])
    end

    it 'renders the clients template' do
      get :clients
      expect(response).to render_template(:clients)
    end
  end
end
