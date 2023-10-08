require 'rails_helper'

RSpec.describe GenerateInvoiceJob, type: :job do
  describe "perform" do
    let(:client) { create(:client) }

    context "when invoice does not exist for the given date" do
      it "creates a new invoice for the client" do
        described_class.perform_sync({ 'client_id' => client.id, 'date' => Date.yesterday }.to_json)
        expect(client.invoices.count).to eq(1)
      end
    end

    context "when invoice already exists for the given date" do
      let(:status) { :generated }

      before do
        create(:client_invoice, client: client, reference_date: Date.yesterday, status: status)
      end

      context "status is generated" do
        it "does not change the status of the existing invoice" do
          existing_invoice = client.invoices.last
          described_class.perform_sync({ 'client_id' => client.id, 'date' => Date.yesterday }.to_json)
          expect(client.invoices.count).to eq(1)
          expect(existing_invoice.reload.status).to eq('generated')
        end      
      end

      context "status is error" do
        let(:status) { :error }

        it "does change the status of the existing invoice" do
          existing_invoice = client.invoices.last
          described_class.perform_sync({ 'client_id' => client.id, 'date' => Date.yesterday }.to_json)
          expect(client.invoices.count).to eq(1)
          expect(existing_invoice.reload.status).to eq('generated')
        end      
      end
    end
  end
end