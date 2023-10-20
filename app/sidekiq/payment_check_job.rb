# frozen_string_literal: true

class PaymentCheckJob < ApplicationJob
  def perform(args = '{}')
    args = JSON.parse(args)
    invoice_id = args['invoice_id']
    invoice = ::Client::Invoice.find(invoice_id)
    payment_check = ::PaymentType.new.payment_check(name: invoice.payment_type).to_sym
    case payment_check
    when :not_needed
      check(invoice)
    when :minutely
      check(invoice)
      PaymentCheckJob.perform_in(1.minute.to_i, { 'invoice_id': invoice.id }.to_json)
    when :hourly
      check(invoice)
      ::PaymentCheckJob.perform_in(1.hour.to_i, { 'invoice_id': invoice.id }.to_json)
    when :daily
      check(invoice)
      ::PaymentCheckJob.perform_in(1.day.to_i, { 'invoice_id': invoice.id }.to_json)
    end
  end

  private

  def check(invoice)
    return if invoice.status == :payed

    invoice.payed_date = Time.now.in_time_zone
    invoice.update(status: :payed)
  end
end
