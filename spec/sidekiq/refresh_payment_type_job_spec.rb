# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshPaymentTypeJob, type: :job do
  describe '#perform' do
    let(:worker) { Sidekiq::Worker }

    it 'enqueues the job correctly' do
      described_class.perform_async

      expect(worker.jobs.size).to eq(1)
      expect(worker.jobs.last['class']).to eq(RefreshPaymentTypeJob.to_s)
    end
  end
end
