require 'rails_helper'

RSpec.describe RescheduleInvoiceWithErrorJob, type: :job do
  describe "perform" do
    let(:worker) { Sidekiq::Worker }

    context "when there are invoices with error status" do
      it "schedules GenerateInvoiceJob for invoices with error status" do
        error_invoice = create(:client_invoice, status: :error)
        non_error_invoice = create(:client_invoice, status: :generated)

        described_class.perform_sync
            
        expect(worker.jobs.size).to eq(1)
        expect(worker.jobs.last['class']).to eq(GenerateInvoiceJob.to_s)
      end
    end

    context "when there are no invoices with error status" do
      it "does not schedule GenerateInvoiceJob" do
        create(:client_invoice, status: :generated)
        create(:client_invoice, status: :generated)

        described_class.perform_sync
        expect(worker.jobs.size).to eq(0)
      end
    end
  end
end