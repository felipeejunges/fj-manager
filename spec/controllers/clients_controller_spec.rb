# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientsController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user, :admin) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #list' do
    let!(:clients) { create_list(:client, 3) }
    it 'renders the list template' do
      get :list
      expect(response).to render_template('clients/_table')
      expect(response).to have_http_status(:ok)
    end

    it 'ordered correctly' do
      get :list, params: { sort_by: 'name', sort_order: 'DESC' }
      expect(assigns(:clients).pluck(:id)).to eq(Client.order(name: :desc).pluck(:id))
    end
  end

  describe 'GET #show' do
    let(:client) { create(:client) }

    it 'returns a success response' do
      get :show, params: { id: client.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    # context 'user is not admin' do
    #  let(:users) { create_list(:user, 2) }
    #  let(:user) { users.first }
    #  it 'redirects to /' do
    #    get :edit, params: { id: users[1].to_param }
    #    expect(response).to be_redirect
    #  end
    # end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:client_plan) { create(:client_plan) }
      let(:client_attributes) { attributes_for(:client).merge(client_plan_id: client_plan.id) }
      it 'creates a new client' do
        expect do
          post :create, params: { client: client_attributes }
        end.to change(Client, :count).by(1)
      end

      it 'redirects to the created client' do
        post :create, params: { client: client_attributes }
        expect(response).to redirect_to(client_url(Client.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new client' do
        expect do
          post :create, params: { client: attributes_for(:client, name: nil) }
        end.not_to change(Client, :count)
      end

      it 'renders the new template' do
        post :create, params: { client: attributes_for(:client, name: nil) }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    let(:client) { create(:client) }

    context 'with valid parameters' do
      it 'updates the requested client' do
        new_name = 'Updated Client Name'
        put :update, params: { id: client.id, client: { name: new_name } }
        client.reload
        expect(client.name).to eq(new_name)
      end

      it 'redirects to the client' do
        put :update, params: { id: client.id, client: attributes_for(:client) }
        expect(response).to redirect_to(client_url(client))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the client' do
        old_name = client.name
        put :update, params: { id: client.id, client: { name: nil } }
        client.reload
        expect(client.name).to eq(old_name)
      end

      it 'renders the edit template' do
        put :update, params: { id: client.id, client: { name: nil } }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:client) { create(:client) }
    it 'destroys the client' do
      client
      expect do
        delete :destroy, params: { id: client.id }
      end.to change(Client, :count).by(-1)
    end

    it "don't destroy the client" do
      allow_any_instance_of(Client).to receive(:destroy).and_return(false)
      client
      expect do
        delete :destroy, params: { id: client.id }
      end.to change(Client, :count).by(0)
    end

    it 'redirects to the client plans index' do
      delete :destroy, params: { id: client.id }
      expect(response).to redirect_to(clients_path)
    end
  end
end
