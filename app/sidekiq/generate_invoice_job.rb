# frozen_string_literal: true

class GenerateInvoiceJob < ApplicationJob
  def perform(args = '{}')
    args = JSON.parse(args)
    date = if args.present? && args['date'].present?
             Date.parse(args['date'])
           else
             Date.current
           end

    client_id = args['client_id']

    client = ::Client.find(client_id)

    return if client.plan.billable_period == 'never'

    invoice = client.invoices.find_by(reference_date: period(date, client.plan))

    if invoice.nil?
      invoice = new_invoice(client, date)
      invoice.save
    end

    return unless %w[generating error].include?(invoice.status)

    integrate(invoice)

    update_payment_day_with_next_payment_day(client)

    ::PaymentCheckJob.perform_in(5, { invoice_id: invoice.id }.to_json) unless %w[generating error].include?(invoice.status)
  end

  private

  def period(date, plan)
    start_date(date, plan.billable_period).beginning_of_month..date.end_of_month
  end

  def start_date(date, billable_period)
    if billable_period == 'yearly'
      date.last_year
    elsif %w[three_months six_months].include?(billable_period)
      date - (1 + Client::Plan.billable_periods[billable_period]).months
    else
      date
    end
  end

  def new_invoice(client, date)
    client.invoices.new(
      description: "Automated ##{client.invoices.count + 1}",
      payment_type: client.payment_type,
      reference_date: date,
      invoice_value: client.net_value,
      plan: client.plan
    )
  end

  def integrate(invoice)
    payment_type = ::PaymentType.new
    klass = payment_type.class_from_integration_by(name: invoice.payment_type)
    klass.constantize.new.perform(invoice.id)
  rescue StandardError => e
    invoice.store_error(e)
  end

  def update_payment_day_with_next_payment_day(client)
    return if client.payment_day == client.next_payment_day

    client.payment_day = client.next_payment_day
    client.save
  end
end
