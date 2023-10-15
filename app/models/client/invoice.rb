# frozen_string_literal: true

class Client::Invoice < ApplicationRecord
  belongs_to :client

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
  scope :range_day_generated, ->(date) { where(status: %i[generated payed late], reference_date: date..date) }
  scope :generated_yesterday, -> { where(status: %i[generated payed late], reference_date: Date.current.yesterday) }

  scope :range_year, ->(date) { where(reference_date: date.beginning_of_year..date.end_of_year) }
  scope :range_month, ->(date) { where(reference_date: date.beginning_of_month..date.end_of_month) }

  def error_logs
    Client::Invoice::ErrorLog.where(client_invoice_id: id)
  end

  def will_retry?
    error_logs.count < max_retries
  end

  def wont_retry?
    !will_retry?
  end

  def store_error(exception)
    self.status = :error
    retry_number = error_logs.count + 1
    error_logs.new(retry_number:, log: exception.to_s, date: Time.now.in_time_zone).save

    return if wont_retry?

    ::GenerateInvoiceJob.perform_in(10,
                                    { 'client_id': client_id,
                                      'date': reference_date }.to_json)

    false
  end

  def error_logs?
    error_logs.present?
  end

  def add_more_retries
    update(max_retries: self.max_retries += 10)
  end
end

# == Schema Information
#
# Table name: client_invoices
#
#  id             :integer          not null, primary key
#  description    :string
#  payment_type   :string
#  reference_date :date
#  status         :integer
#  payed_date     :datetime
#  invoice_value  :float
#  max_retries    :integer          default(10)
#  client_id      :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  client_plan_id :integer
#
# Indexes
#
#  index_client_invoices_on_client_id  (client_id)
#
# Foreign Keys
#
#  client_id       (client_id => clients.id)
#  client_plan_id  (client_plan_id => client_plans.id)
#
