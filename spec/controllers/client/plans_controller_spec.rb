# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client::PlansController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user, :admin) }
  let(:client_plan) { create(:client_plan) }
  let(:client_plans) { create_list(:client_plan, 3) }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'renders the index template' do
      client_plans
      get :index
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @client_plans' do
      client_plans
      get :index
      expect(assigns(:client_plans).pluck(:id)).to eq(Client::Plan.all.order(:id).pluck(:id))
    end

    it 'ordered correctly' do
      get :index, params: { sort_by: 'name', sort_order: 'DESC' }
      expect(assigns(:client_plans).pluck(:id)).to eq(Client::Plan.order(name: :desc).pluck(:id))
    end
  end

  describe 'GET #list' do
    it 'renders the list template' do
      client_plans
      get :list
      expect(response).to render_template('client/plans/_table')
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @client_plans' do
      client_plans
      get :list
      expect(assigns(:client_plans).pluck(:id)).to eq(Client::Plan.all.order(:id).pluck(:id))
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: client_plan.id }
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @client_plan' do
      get :show, params: { id: client_plan.id }
      expect(assigns(:client_plan)).to eq(client_plan)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:ok)
    end

    it 'assigns a new Client::Plan to @client_plan' do
      get :new
      expect(assigns(:client_plan)).to be_a_new(Client::Plan)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new client plan' do
        expect do
          post :create, params: { client_plan: FactoryBot.attributes_for(:client_plan) }
        end.to change(Client::Plan, :count).by(1)
      end

      it 'redirects to the created client plan' do
        post :create, params: { client_plan: FactoryBot.attributes_for(:client_plan) }
        expect(response).to redirect_to(client_plan_path(Client::Plan.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new client plan' do
        expect do
          post :create, params: { client_plan: { name: nil } }
        end.to_not change(Client::Plan, :count)
      end

      it 're-renders the new template' do
        post :create, params: { client_plan: { name: nil } }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { id: client_plan.id }
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:ok)
    end

    it 'assigns the requested client plan to @client_plan' do
      get :edit, params: { id: client_plan.id }
      expect(assigns(:client_plan)).to eq(client_plan)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the client plan' do
        new_name = 'New Plan Name'
        patch :update, params: { id: client_plan.id, client_plan: { name: new_name } }
        client_plan.reload
        expect(client_plan.name).to eq(new_name)
      end

      it 'redirects to the client plan' do
        patch :update, params: { id: client_plan.id, client_plan: { name: 'Updated Plan Name' } }
        expect(response).to redirect_to(client_plan_path(client_plan))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the client plan' do
        old_name = client_plan.name
        patch :update, params: { id: client_plan.id, client_plan: { name: nil } }
        client_plan.reload
        expect(client_plan.name).to eq(old_name)
      end

      it 're-renders the edit template' do
        patch :update, params: { id: client_plan.id, client_plan: { name: nil } }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the client plan' do
      client_plan
      expect do
        delete :destroy, params: { id: client_plan.id }
      end.to change(Client::Plan, :count).by(-1)
    end

    it "don't destroy the client plan" do
      allow_any_instance_of(Client::Plan).to receive(:destroy).and_return(false)
      client_plan
      expect do
        delete :destroy, params: { id: client_plan.id }
      end.to change(Client::Plan, :count).by(0)
    end

    it 'redirects to the client plans index' do
      delete :destroy, params: { id: client_plan.id }
      expect(response).to redirect_to(client_plans_path)
    end
  end
end
