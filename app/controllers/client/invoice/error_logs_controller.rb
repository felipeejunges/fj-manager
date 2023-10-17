# frozen_string_literal: true

class Client::Invoice::ErrorLogsController < ApplicationController
  before_action :set_client
  before_action :set_client_invoice
  before_action :set_client_invoice_error_log, only: :show
  before_action :set_error_logs, only: :index

  # GET /clients/1/invoices/1/error_logs/1 or /clients/1/invoices/1/error_logs/1.json
  def index
    render(partial: 'client/invoice/error_logs/table', locals: { error_logs: @error_logs })
  end

  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client_invoice_error_log
    @error_log = @invoice.error_logs.find(params[:id])
  end

  def set_client_invoice
    @invoice = @client.invoices.find(params[:invoice_id])
  end

  def set_client
    @client = Client.find(params[:client_id])
  end

  # Only allow a list of trusted parameters through.
  def client_invoice_error_log_params
    params.require(:client_invoice_error_log).permit(:client_invoice_id, :retry_number, :date, :log)
  end

  def set_error_logs
    @error_logs = @invoice.error_logs.all
    sort_error_logs
    @pagy, @error_logs = pagy(@error_logs)
  end

  def allow_sort
    %w[id retry_number date].include?(params[:sort_by].to_s)
  end

  def sort_error_logs
    return unless allow_sort

    sort = { params[:sort_by].to_sym => params[:sort_order] == 'DESC' ? 'DESC' : 'ASC' }

    @error_logs = @error_logs.order(sort)
  end
end
