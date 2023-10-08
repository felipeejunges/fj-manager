# frozen_string_literal: true

class RescheduleInvoiceWithErrorJob < ApplicationJob
  def perform(*_args)
    Client::Invoice.where(status: :error).each do |invoice|
      next if invoice.wont_retry?

      ::GenerateInvoiceJob.perform_in(5, { 'client_id': invoice.client_id, date: invoice.reference_date }.to_json)
    end
  end
end
