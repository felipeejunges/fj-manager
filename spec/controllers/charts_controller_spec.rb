# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChartsController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user) }
  let(:params) { {} }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do # rubocop:disable Metrics/BlockLength
    before do
      get :index, params:
    end

    context 'without parameter' do
      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it 'error_logs_by_payment_type' do
        expect(assigns(:error_logs_by_payment_type)).to eq({ 'No Errors' => 1 })
      end

      it 'last_3_years_invoices_by_month' do
        expect(assigns(:last_3_years_invoices_by_month)).to eq([{ data: {}, name: 2023 }, { data: {}, name: 2022 },
                                                                { data: {}, name: 2021 }])
      end

      it 'last_3_months_invoices_by_day' do
        expect(assigns(:last_3_months_invoices_by_day)).to eq([{ data: {}, name: 'October' }, { data: {}, name: 'September' },
                                                               { data: {}, name: 'August' }])
      end

      it 'payment_day_by_client' do
        expect(assigns(:payment_day_by_client)).to eq({ 'No Payment Days' => 1 })
      end

      it 'payment_type_by_client' do
        expect(assigns(:payment_type_by_client)).to eq({ 'No Payment Type' => 1 })
      end
    end

    context "'type parameter as 'money'" do
      let(:params) { { type: 'money' } }
      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it 'error_logs_by_payment_type' do
        expect(assigns(:error_logs_by_payment_type)).to eq({ 'No Errors' => 1 })
      end

      it 'last_3_years_invoices_by_month' do
        expect(assigns(:last_3_years_invoices_by_month)).to eq([{ data: {}, name: 2023 }, { data: {}, name: 2022 },
                                                                { data: {}, name: 2021 }])
      end

      it 'last_3_months_invoices_by_day' do
        expect(assigns(:last_3_months_invoices_by_day)).to eq([{ data: {}, name: 'October' }, { data: {}, name: 'September' },
                                                               { data: {}, name: 'August' }])
      end

      it 'payment_day_by_client' do
        expect(assigns(:payment_day_by_client)).to eq({ 'No Payment Days' => 1 })
      end

      it 'payment_type_by_client' do
        expect(assigns(:payment_type_by_client)).to eq({ 'No Payment Type' => 1 })
      end
    end
  end
end
