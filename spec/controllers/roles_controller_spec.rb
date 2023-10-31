# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RolesController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user, :admin) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  let(:valid_attributes) do
    { name: 'Role', code: 'role', description: 'Description' }
  end

  let(:invalid_attributes) do
    { name: '', code: '', description: '' }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      create(:role)
      get :index
      expect(response).to be_successful
      expect(assigns(:roles).pluck(:id)).to eq(Role.all.order(:id).pluck(:id))
    end
  end

  describe 'GET #list' do
    let!(:roles) { create_list(:role, 3) }
    it 'renders the list template' do
      get :list
      expect(response).to render_template('roles/_table')
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @roles' do
      get :list
      expect(assigns(:roles).pluck(:id)).to eq(Role.all.order(:id).pluck(:id))
    end

    it 'ordered by name correctly' do
      get :list, params: { sort_by: 'name', sort_order: 'DESC' }
      expect(assigns(:roles).pluck(:id)).to eq(Role.order(name: :desc).pluck(:id))
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      role = Role.create! valid_attributes
      get :show, params: { id: role.to_param }
      expect(response).to be_successful
      expect(assigns(:role)).to eq(role)
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
      role = Role.create! valid_attributes
      get :edit, params: { id: role.to_param }
      expect(response).to be_successful
      expect(assigns(:role)).to eq(role)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Role' do
        expect do
          post :create, params: { role: valid_attributes }
        end.to change(Role, :count).by(1)
      end

      it 'redirects to the created role' do
        post :create, params: { role: valid_attributes }
        expect(response).to redirect_to(Role.last)
      end
    end

    context 'with invalid params' do
      it 'returns a success response' do
        post :create, params: { role: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'Updated Name' }
      end

      it 'updates the requested role' do
        role = Role.create! valid_attributes
        put :update, params: { id: role.to_param, role: new_attributes }
        role.reload
        expect(role.name).to eq('Updated Name')
      end

      it 'redirects to the role' do
        role = Role.create! valid_attributes
        put :update, params: { id: role.to_param, role: valid_attributes }
        expect(response).to redirect_to(role)
      end
    end

    context 'with invalid params' do
      it 'returns a success response' do
        role = Role.create! valid_attributes
        put :update, params: { id: role.to_param, role: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PATCH #apply_permission' do
    context 'with valid params' do
      let!(:permission) { create(:permission) }
      let!(:role) { create(:role) }

      it 'add permission when it dont exist' do
        put :apply_permission, params: { id: role.id, key: permission.key, p_action: permission.action }
        expect(role.permissions.where(id: permission.id)).to exist
      end

      it 'remove permission when it exists' do
        role.permissions << permission
        put :apply_permission, params: { id: role.id, key: permission.key, p_action: permission.action }
        expect(role.permissions.where(id: permission.id)).to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested role' do
      role = Role.create! valid_attributes
      expect do
        delete :destroy, params: { id: role.to_param }
      end.to change(Role, :count).by(-1)
    end

    it "don't destroy the client plan" do
      allow_any_instance_of(Role).to receive(:destroy).and_return(false)
      role = Role.create! valid_attributes
      expect do
        delete :destroy, params: { id: role.id }
      end.to change(Role, :count).by(0)
    end

    it 'redirects to the roles list' do
      role = Role.create! valid_attributes
      delete :destroy, params: { id: role.to_param }
      expect(response).to redirect_to(roles_url)
    end
  end
end
