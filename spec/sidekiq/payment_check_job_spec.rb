# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCheckJob, type: :job do # rubocop:disable Metrics/BlockLength
  describe 'perform' do # rubocop:disable Metrics/BlockLength
    let(:payment_check) { 'not_needed' }
    let(:payment_type) { 'debit_card' }
    let(:client) { create(:client, payment_type:) }
    let(:invoice) { create(:client_invoice, status: :generating, payment_type:, client:) }

    before do
      PaymentType.store
      allow_any_instance_of(PaymentType).to receive(:payment_check).and_return(payment_check)
    end

    it 'updates invoice status to :payed' do
      expect { described_class.perform_sync({ 'invoice_id' => invoice.id }.to_json) }
        .to change { invoice.reload.status }.from('generating').to('payed')
    end

    it 'does not update invoice status if already :payed' do
      invoice.update(status: :payed)
      expect { described_class.perform_sync({ 'invoice_id' => invoice.id }.to_json) }
        .not_to(change { invoice.reload.status })
    end

    describe 'schedules the next PaymentCheckJob if payment check is' do # rubocop:disable Metrics/BlockLength
      let(:worker) { Sidekiq::Worker }

      context ':minutely' do
        let(:payment_check) { 'minutely' }
        it 'should' do
          described_class.perform_sync({ 'invoice_id' => invoice.id }.to_json)

          expect(worker.jobs.last['at'].to_i).to eq(1.minute.from_now.to_i)
          expect(worker.jobs.size).to eq(1)
          expect(worker.jobs.last['class']).to eq(PaymentCheckJob.to_s)
        end
      end

      context ':hourly' do
        let(:payment_check) { 'hourly' }
        it 'should' do
          described_class.perform_sync({ 'invoice_id' => invoice.id }.to_json)

          expect(worker.jobs.last['at'].to_i).to eq(1.hour.from_now.to_i)
          expect(worker.jobs.size).to eq(1)
          expect(worker.jobs.last['class']).to eq(PaymentCheckJob.to_s)
        end
      end

      context ':daily' do
        let(:payment_check) { 'daily' }
        it 'should' do
          described_class.perform_sync({ 'invoice_id' => invoice.id }.to_json)

          expect(worker.jobs.last['at'].to_i).to eq(1.day.from_now.to_i)
          expect(worker.jobs.size).to eq(1)
          expect(worker.jobs.last['class']).to eq(PaymentCheckJob.to_s)
        end
      end
    end
  end
end
