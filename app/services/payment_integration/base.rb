# frozen_string_literal: true

class PaymentIntegration::Base
  PAYMENT_CHECK = 'not_needed'

  def perform(invoice_id)
    invoice = Client::Invoice.find(invoice_id)
    begin
      integrate
      invoice.status = :generated
      invoice.save
    rescue StandardError => e
      invoice.status = :error
      retry_number = invoice_error_logs.count + 1
      error_log = invoice.error_logs.new(retry_number:, log: e.to_s, date: Time.now)
      error_log.save
      GenerateInvoiceJob.perform_in(30, { 'client_id': invoice.client_id, 'date': invoice.reference_date }.to_json)
      false
    end
  end

  private

  def integrate; end
end
