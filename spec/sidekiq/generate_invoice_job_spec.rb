# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateInvoiceJob, type: :job do # rubocop:disable Metrics/BlockLength
  describe 'perform' do # rubocop:disable Metrics/BlockLength
    let(:billable_period) { :monthly }
    let(:client_plan) { create(:client_plan, billable_period:) }
    let(:next_payment_day) { Date.current.day }
    let(:client) { create(:client, client_plan_id: client_plan.id, payment_day: Date.current.day, next_payment_day:) }

    context 'when invoice does not exist for the given date' do
      it 'creates a new invoice for the client' do
        described_class.perform_sync({ 'client_id' => client.id, 'date' => Date.current }.to_json)
        expect(client.invoices.count).to eq(1)
      end

      context 'when date is not set and new payment day is different from payment day' do
        let(:next_payment_day) { Date.tomorrow.day }
        it 'creates a new invoice for the client' do
          described_class.perform_sync({ 'client_id' => client.id }.to_json)
          expect(client.invoices.count).to eq(1)
        end
      end

      context 'when billable period is :yearly' do
        let(:billable_period) { :yearly }
        it 'creates a new invoice for the client' do
          described_class.perform_sync({ 'client_id' => client.id, 'date' => Date.current }.to_json)
          expect(client.invoices.count).to eq(1)
        end
      end

      context 'when billable period is :three_months' do
        let(:billable_period) { :three_months }
        it 'creates a new invoice for the client' do
          described_class.perform_sync({ 'client_id' => client.id, 'date' => Date.current }.to_json)
          expect(client.invoices.count).to eq(1)
        end
      end

      context 'when billable period is :three_months' do
        it 'creates a new invoice for the client' do
          allow_any_instance_of(PaymentType).to receive(:integrations).and_raise(StandardError, 'Integration error message')
          described_class.perform_sync({ 'client_id' => client.id, 'date' => Date.current }.to_json)
          expect(client.invoices.count).to eq(1)
          expect(client.invoices.last.status).to eq('error')
        end
      end
    end

    context 'when invoice already exists for the given date' do
      let(:status) { :generated }

      before do
        create(:client_invoice, client:, reference_date: Date.current, status:)
      end

      context 'status is generated' do
        it 'does not change the status of the existing invoice' do
          existing_invoice = client.invoices.last
          described_class.perform_sync({ 'client_id' => client.id, 'date' => Date.current }.to_json)
          expect(client.invoices.count).to eq(1)
          expect(existing_invoice.reload.status).to eq('generated')
        end
      end

      context 'status is error' do
        let(:status) { :error }

        it 'does change the status of the existing invoice' do
          existing_invoice = client.invoices.last
          described_class.perform_sync({ 'client_id' => client.id, 'date' => Date.current }.to_json)
          expect(client.invoices.count).to eq(1)
          expect(existing_invoice.reload.status).to eq('generated')
        end
      end
    end
  end
end
