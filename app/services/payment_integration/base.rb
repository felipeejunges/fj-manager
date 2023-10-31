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
      invoice.store_error(e)
    end
  end

  private

  def integrate; end
end
