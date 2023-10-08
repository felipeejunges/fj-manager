# spec/controllers/user_sessions_controller_spec.rb

require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do
  let(:password) { '123' }
  let(:user) { create(:user, password: password) }

  describe 'GET #login' do
    it 'renders the login template' do
      get :login
      expect(response).to render_template(:login)
    end
  end

  describe 'POST #authenticate' do
    context 'with valid credentials' do
      it 'redirects to the root path' do
        post :authenticate, params: { user: { email: user.email, password: password } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid credentials' do
      it 'renders the login template' do
        post :authenticate, params: { user: { email: user.email, password: 'invalid_password' } }
        expect(response).to render_template(:login)
      end
    end
  end

  describe 'GET #logout' do
    it 'redirects to the login path' do
      get :logout
      expect(response).to redirect_to(login_path)
    end
  end
end
