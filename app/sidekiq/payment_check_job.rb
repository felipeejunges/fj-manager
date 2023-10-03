# frozen_string_literal: true

class PaymentCheckJob < ApplicationJob
  def perform(args = '{}')
    args = JSON.parse(args)
    invoice_id = args['invoice_id']
    invoice = ::Client::Invoice.find(invoice_id)
    payment_type = ::PaymentType.new
    klass = payment_type.integration_by(name: invoice.client.payment_type)['class']
    payment_check = klass.constantize.const_get(:PAYMENT_CHECK).to_sym
    if payment_check == :not_needed
      check(invoice)
    elsif payment_check == :minutely
      check(invoice)
      PaymentCheckJob.perform_in(60, { 'invoice_id': invoice.id }.to_json)
    elsif payment_check == :hourly
      check(invoice)
      ::PaymentCheckJob.perform_in(3600, { 'invoice_id': invoice.id }.to_json)
    elsif payment_check == :daily
      check(invoice)
      ::PaymentCheckJob.perform_in(86_400, { 'invoice_id': invoice.id }.to_json)
    end
  end

  private

  def check(invoice)
    return if invoice.status == :payed

    invoice.payed_date = Time.now
    invoice.status = :payed
    invoice.save
  end
end
