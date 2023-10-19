# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :set_chart, only: %i[show edit update destroy]
  helper_method :error_logs_by_payment_type, :last_2_years_invoices_by_month, :last_3_months_invoices_by_day, :payment_day_by_client,
                :payment_type_by_client, :ytitle

  # GET /charts or /charts.json
  def index; end

  private

  def error_logs_by_payment_type
    return @error_logs_by_payment_type if @error_logs_by_payment_type.present?

    @error_logs_by_payment_type = {}
    Client::Invoice::ErrorLog.all.group_by(&:payment_type).each { |k, i| @error_logs_by_payment_type.merge!(k => i.count) }
    @error_logs_by_payment_type
  end

  def last_2_years_invoices_by_month
    3.times.map do |i|
      date = Time.current - i.year
      data = Client::Invoice.range_year_generated(date).group_by_month(:reference_date, format: '%b')
      data = if params[:type] == 'money'
               data.sum(:invoice_value)
             else
               data.count
             end
      { name: date.year, data: }
    end
  end

  def last_3_months_invoices_by_day
    3.times.map do |i|
      date = Time.current - i.month
      data = Client::Invoice.range_month_generated(date).group_by_day(:reference_date, format: '%d')
      data = if params[:type] == 'money'
               data.sum(:invoice_value)
             else
               data.count
             end
      { name: date.strftime('%B'), data: }
    end
  end

  def payment_day_by_client
    Client.group(:payment_day).count
  end

  def payment_type_by_client
    data = Client.group(:payment_type)
    if params[:type] == 'money'
      data.includes(:plan).sum('client_plans.price - ((client_plans.price * clients.discount) / 100)')
    else
      data.count
    end
  end

  def ytitle
    params[:type]&.humanize || 'Quantity'
  end
end
