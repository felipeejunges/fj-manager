# frozen_string_literal: true

# spec/controllers/user_sessions_controller_spec.rb

require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:password) { '123' }
  let(:user) { create(:user, password:, password_confirmation: password) }

  describe 'GET #login' do
    it 'renders the login template' do
      get :signin
      expect(response).to render_template(:signin)
    end

    context 'already logged' do
      it 'renders the login template' do
        allow(controller).to receive(:current_user).and_return(user)
        get :signin
        expect(response).not_to be_redirect
      end
    end
  end

  describe 'POST #authenticate' do
    context 'with valid credentials' do
      it 'redirects to the root path' do
        post :authenticate, params: { user: { email: user.email, password: } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid credentials' do
      it 'renders the login template' do
        post :authenticate, params: { user: { email: user.email, password: 'invalid_password' } }
        expect(response).to render_template(:signin)
      end
    end
  end

  describe 'GET #logout' do
    it 'redirects to the login path' do
      get :signout
      expect(response).to redirect_to(login_path)
    end
  end
end
