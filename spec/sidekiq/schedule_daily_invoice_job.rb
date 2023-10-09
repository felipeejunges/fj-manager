# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleDailyInvoiceJob, type: :job do
  describe 'perform' do
    it 'enqueues GenerateInvoiceJob' do
      create(:client, payment_day: Date.tomorrow)
      create(:client, payment_day: Date.today)
      create(:client, payment_day: Date.yesterday)

      described_class.perform_sync

      expect(worker.jobs.size).to eq(1)
      expect(worker.jobs.last['class']).to eq(GenerateInvoiceJob.to_s)
    end

    it "does not enqueue GenerateInvoiceJob if there are no clients with today's payment day" do
      described_class.perform_sync
      expect(worker.jobs.size).to eq(0)
    end
  end
end
