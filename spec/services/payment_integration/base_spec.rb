require 'rails_helper'

RSpec.describe PaymentIntegration::Base do
  let(:invoice) { create(:client_invoice, status: :generating) }
  let(:payment_integration) { PaymentIntegration::Base.new }

  describe '#perform' do
    context 'when integration is successful' do
      it 'updates invoice status to generated' do
        allow(payment_integration).to receive(:integrate).and_return(true)

        expect {
          payment_integration.perform(invoice.id)
          invoice.reload
        }.to change { invoice.status }.from('generating').to('generated')
      end
    end

    context 'when integration raises an error' do
      it 'updates invoice status to error and stores the error message' do
        allow_any_instance_of(PaymentIntegration::Base).to receive(:integrate).and_raise(StandardError, 'Integration error message')
        allow_any_instance_of(GenerateInvoiceJob).to receive(:perform).and_raise(StandardError, 'Generating error message')

        payment_integration.perform(invoice.id)

        expect(invoice.error_logs.last.log).to eq('Integration error message')
      end
    end
  end
end