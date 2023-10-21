# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user, :admin) }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  let(:valid_attributes) do
    { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'password123' }
  end

  let(:invalid_attributes) do
    { first_name: '', last_name: '', email: 'invalid_email', password: 'short' }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      create(:user)
      get :index
      expect(response).to be_successful
      expect(assigns(:users).pluck(:id)).to eq(User.all.order(:id).pluck(:id))
    end
  end

  describe 'GET #list' do
    let!(:users) { create_list(:user, 3) }
    it 'renders the list template' do
      get :list
      expect(response).to render_template('users/_table')
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @users' do
      get :list
      expect(assigns(:users).pluck(:id)).to eq(User.all.order(:id).pluck(:id))
    end

    it 'ordered by email correctly' do
      get :list, params: { sort_by: 'email', sort_order: 'DESC' }
      expect(assigns(:users).pluck(:id)).to eq(User.order(email: :desc).pluck(:id))
    end

    it 'ordered by name correctly' do
      get :list, params: { sort_by: 'name', sort_order: 'DESC' }
      expect(assigns(:users).pluck(:id)).to eq(User.order({ first_name: :desc, last_name: :desc }).pluck(:id))
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      user = User.create! valid_attributes
      get :show, params: { id: user.to_param }
      expect(response).to be_successful
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      user = User.create! valid_attributes
      get :edit, params: { id: user.to_param }
      expect(response).to be_successful
      expect(assigns(:user)).to eq(user)
    end

    context 'user is not admin' do
      let(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      it 'redirects to /' do
        get :edit, params: { id: users[1].to_param }
        expect(response).to be_redirect
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(User.last)
      end
    end

    context 'with invalid params' do
      it 'returns a success response' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { first_name: 'Updated Name' }
      end

      it 'updates the requested user' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.first_name).to eq('Updated Name')
      end

      it 'redirects to the user' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: valid_attributes }
        expect(response).to redirect_to(user)
      end
    end

    context 'with invalid params' do
      it 'returns a success response' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect do
        delete :destroy, params: { id: user.to_param }
      end.to change(User, :count).by(-1)
    end

    it "don't destroy the client plan" do
      allow_any_instance_of(User).to receive(:destroy).and_return(false)
      user = User.create! valid_attributes
      expect do
        delete :destroy, params: { id: user.id }
      end.to change(User, :count).by(0)
    end

    it 'redirects to the users list' do
      user = User.create! valid_attributes
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(users_url)
    end
  end
end
