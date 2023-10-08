require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
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
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new client' do
        expect {
          post :create, params: { client: attributes_for(:client) }
        }.to change(Client, :count).by(1)
      end

      it 'redirects to the created client' do
        post :create, params: { client: attributes_for(:client) }
        expect(response).to redirect_to(client_url(Client.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new client' do
        expect {
          post :create, params: { client: attributes_for(:client, name: nil) }
        }.not_to change(Client, :count)
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
end