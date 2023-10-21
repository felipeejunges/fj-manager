# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :set_chart, only: %i[show edit update destroy]
  helper_method :error_logs_by_payment_type, :last_3_years_invoices_by_month, :last_3_months_invoices_by_day, :payment_day_by_client,
                :payment_type_by_client, :ytitle

  # GET /charts or /charts.json
  def index
    error_logs_by_payment_type
    last_3_years_invoices_by_month
    last_3_months_invoices_by_day
    payment_day_by_client
    payment_type_by_client
    ytitle
  end

  private

  def error_logs_by_payment_type
    @error_logs_by_payment_type = {}
    Client::Invoice::ErrorLog.all.group_by(&:payment_type).each { |k, i| error_logs_by_payment_type.merge!(k => i.count) }
    return @error_logs_by_payment_type if @error_logs_by_payment_type != {}

    @error_logs_by_payment_type = { 'No Errors' => 1 }
  end

  def last_3_years_invoices_by_month
    return @last_3_years_invoices_by_month if @last_3_years_invoices_by_month.present?

    @last_3_years_invoices_by_month = 3.times.map do |i|
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
    return @last_3_months_invoices_by_day if @last_3_months_invoices_by_day.present?

    @last_3_months_invoices_by_day = 3.times.map do |i|
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
    return @payment_day_by_client if @payment_day_by_client.present?

    @payment_day_by_client = Client.group(:payment_day).count

    return @payment_day_by_client if @payment_day_by_client != {}

    @payment_day_by_client = { 'No Payment Days' => 1 }
  end

  def payment_type_by_client
    return @payment_type_by_client if @payment_type_by_client.present?

    data = Client.group(:payment_type)
    @payment_type_by_client = if params[:type] == 'money'
                                data.includes(:plan).sum('client_plans.price - ((client_plans.price * clients.discount) / 100)')
                              else
                                data.count
                              end
    return @payment_type_by_client if @payment_type_by_client != {}

    @payment_type_by_client = { 'No Payment Type' => 1 }
  end

  def ytitle
    return @ytitle if @ytitle.present?

    @ytitle = params[:type]&.humanize || 'Quantity'
  end
end
