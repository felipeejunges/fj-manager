# frozen_string_literal: true

class Client < ApplicationRecord
  include ClientsHelper

  has_many :invoices, class_name: 'Client::Invoice', inverse_of: :client, dependent: :destroy
  belongs_to :plan, foreign_key: :client_plan_id, class_name: 'Client::Plan'
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'

  enum document_type: {
    cnpj: 1,
    cpf: 2
  }

  before_validation :ensure_next_payment_day_be_filled

  validates :name, :document, :document_type, :payment_type, :payment_day, :discount, presence: true

  validate :discount_less_or_equal_than_plan_max_discount

  def ensure_next_payment_day_be_filled
    self.next_payment_day = payment_day if next_payment_day.nil? || next_payment_day.zero? || next_payment_day > 31
  end

  def discount_less_or_equal_than_plan_max_discount
    return if plan.present? && discount <= plan.max_discount

    errors.add(:discount, :invalid, message: 'must be less or equal than plan max discount')
  end

  def net_value
    pp = plan.price
    pp - ((pp * discount) / 100)
  end

  def error_logs
    Client::Invoice::ErrorLog.where(:client_invoice_id.in => invoices.pluck(:id))
  end

  def current_status
    @current_status ||= invoices.order(reference_date: :desc).first.status if invoices.present?
  end

  def expected_earnings_this_year
    return @expected_earnings_this_year if @expected_earnings_this_year.present?

    extra = created_at < created_at.beginning_of_year ? created_at.month : 0

    pendency_value = (12 - extra - generated_invoices_this_year) * net_value
    pendency_value = 0 if pendency_value.negative?

    late_summed = invoices.late.range_year(Time.now.in_time_zone).sum(:invoice_value)
    @expected_earnings_this_year = earnings_this_year + pendency_value + late_summed
  end

  def expected_earnings_comparisson_yearly
    @expected_earnings_comparisson_yearly ||= calculate_percentage_difference(earnings_last_year, expected_earnings_this_year)
  end

  def earnings_this_year
    @earnings_this_year ||= invoices.payed.range_year(Time.now.in_time_zone).sum(:invoice_value)
  end

  def earnings_last_year
    @earnings_last_year ||= invoices.payed.range_year(Time.now.in_time_zone.last_year).sum(:invoice_value)
  end

  def earnings_comparisson_yearly
    @earnings_comparisson_yearly ||= calculate_percentage_difference(earnings_last_month, earnings_this_year)
  end

  def errors_this_year
    @errors_this_year ||= error_logs.range_year(Time.now.in_time_zone).count
  end

  def errors_last_year
    @errors_last_year ||= error_logs.range_year(Time.now.in_time_zone.last_year).count
  end

  def errors_comparisson_yearly
    @errors_comparisson_yearly ||= calculate_percentage_difference(errors_last_year, errors_this_year)
  end

  def generated_invoices_this_year
    @generated_invoices_this_year ||= invoices.range_year_generated(Time.now.in_time_zone).count
  end

  def generated_invoices_last_year
    @generated_invoices_last_year ||= invoices.range_year_generated(Time.now.in_time_zone.last_year).count
  end

  def generated_invoices_comparisson_yearly
    @generated_invoices_comparisson_yearly ||= calculate_percentage_difference(generated_invoices_last_year, generated_invoices_this_year)
  end

  def earnings_this_month
    @earnings_this_month ||= invoices.payed.range_month(Time.now.in_time_zone).sum(:invoice_value)
  end

  def earnings_last_month
    @earnings_last_month ||= invoices.payed.range_month(Time.now.in_time_zone.last_month).sum(:invoice_value)
  end

  def earnings_comparisson_monthly
    @earnings_comparisson_monthly ||= calculate_percentage_difference(earnings_last_month, earnings_this_month)
  end

  def errors_this_month
    @errors_this_month ||= error_logs.range_month(Time.now.in_time_zone).count
  end

  def errors_last_month
    @errors_last_month ||= error_logs.range_month(Time.now.in_time_zone.last_month).count
  end

  def errors_comparisson_monthly
    @errors_comparisson_monthly ||= calculate_percentage_difference(errors_last_month, errors_this_month)
  end
end

# == Schema Information
#
# Table name: clients
#
#  id               :integer          not null, primary key
#  name             :string
#  document         :string
#  document_type    :integer
#  payment_type     :string
#  payment_day      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  discount         :float            default(0.0)
#  email            :string
#  next_payment_day :integer
#  client_plan_id   :integer
#  created_by_id    :integer
#
# Foreign Keys
#
#  client_plan_id  (client_plan_id => client_plans.id)
#  created_by_id   (created_by_id => users.id)
#
