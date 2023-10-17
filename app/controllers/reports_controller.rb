# frozen_string_literal: true

class ReportsController < ApplicationController
  def new_clients
    if params[:start_date].nil? && params[:end_date].nil?
      params[:start_date] = Date.current.strftime
      params[:end_date] = Date.current.strftime
    end

    @clients = Client.all
    @clients = @clients.where(payment_type:) if payment_type.present?
    @clients = @clients.where(created_at: start_date..end_date)

    @clients
  end

  def clients_invoiced_yesterday
    client_ids = Client::Invoice.generated_yesterday.pluck(:client_id).uniq
    @clients = Client.where(id: client_ids)
    @clients = @clients.where(payment_type:) if payment_type.present?
    @clients = @clients.where(document_type:) if document_type.present?
    @clients
  end

  def clients
    @clients = if status.present?
                 Client.where(id: Client::Invoice.where(status:).pluck(:client_id).uniq)
               else
                 Client.all
               end
    @clients = @clients.where(payment_type:) if payment_type.present?
    @clients = @clients.where(document_type:) if document_type.present?
    @clients
  end

  private

  def start_date
    return @start_date if @start_date.present?

    date = params.permit(:start_date)[:start_date]
    return unless date.present?

    @start_date = Date.parse(date).beginning_of_day
  end

  def end_date
    return @end_date if @end_date.present?

    date = params.permit(:end_date)[:end_date]
    return unless date.present?

    @end_date = Date.parse(date).end_of_day
  end

  def status
    @status ||= params.permit(:status)[:status]
  end

  def payment_type
    @payment_type ||= params.permit(:payment_type)[:payment_type]
  end

  def document_type
    @document_type ||= params.permit(:document_type)[:document_type]
  end
end
