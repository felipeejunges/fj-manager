# frozen_string_literal: true

class Client::Invoice < ApplicationRecord
  belongs_to :client
  has_many :error_logs, class_name: 'Client::Invoice::ErrorLog', foreign_key: :client_invoice_id, inverse_of: :invoice

  enum status: {
    generating: 0,
    generated: 1,
    error: 2,
    payed: 3,
    late: 4
  }, _default: 'generating'

  validates :invoice_value, :payment_type, presence: true

  scope :range_year_generated, ->(date) { where(status: %i[generated payed late], reference_date: date.beginning_of_year..date.end_of_year) }
  scope :range_month_generated, ->(date) { where(status: %i[generated payed late], reference_date: date.beginning_of_month..date.end_of_month) }
  scope :range_day_generated, ->(date) { where(status: %i[generated payed late], reference_date: date.beginning_of_day..date.end_of_day) }

  scope :range_year, ->(date) { where(reference_date: date.beginning_of_year..date.end_of_year) }
  scope :range_month, ->(date) { where(reference_date: date.beginning_of_month..date.end_of_month) }

  def will_retry?
    max_retries < error_logs.count && status == :error
  end

  def store_error(exception)
    invoice.status = :error
    retry_number = invoice_error_logs.count + 1
    invoice.error_logs.new(retry_number:, log: exception.to_s, date: Time.now).save

    return unless invoice.max_retries < invoice.error_logs.count

    GenerateInvoiceJob.perform_in(30,
                                  { 'client_id': invoice.client_id,
                                    'date': invoice.reference_date }.to_json)

    false
  end

  def error_logs?
    error_logs.present?
  end

  def add_more_retries
    self.max_retries += 10
    update
  end
end
