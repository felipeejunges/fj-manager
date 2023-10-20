# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChartsController, type: :controller do
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
