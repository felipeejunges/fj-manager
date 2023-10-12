# frozen_string_literal: true

class GenerateInvoiceJob < ApplicationJob
  def perform(args = '{}')
    args = JSON.parse(args)
    date = if args.present? && args['date'].present?
             Date.parse(args['date'])
           else
             Date.current.yesterday
           end

    client_id = args['client_id']

    client = ::Client.find(client_id)

    invoice = client.invoices.find_by(reference_date: date.beginning_of_month..date.end_of_month)

    if invoice.nil?
      invoice = new_invoice(client, date)
      invoice.save
    end

    return unless %w[generating error].include?(invoice.status)

    integrate(invoice, client)

    ::PaymentCheckJob.perform_in(5, { invoice_id: invoice.id }.to_json)
  end

  private

  def new_invoice(client, date)
    client.invoices.new(
      description: "Automated ##{client.invoices.count + 1}",
      payment_type: client.payment_type,
      reference_date: date,
      invoice_value: client.plan_value
    )
  end

  def integrate(invoice, _client)
    payment_type = ::PaymentType.new
    klass = payment_type.class_from_integration_by(name: invoice.payment_type)
    klass.constantize.new.perform(invoice.id)
  rescue StandardError => e
    invoice.store_error(e)
  end
end
