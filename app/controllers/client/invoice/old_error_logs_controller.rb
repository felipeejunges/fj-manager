# frozen_string_literal: true

class Client::Invoice::OldErrorLogsController < ApplicationController
  before_action :authenticate_user
  before_action :set_client
  before_action :set_client_invoice
  before_action :set_client_invoice_old_error_log, only: :show
  before_action :set_old_error_logs, only: :index

  # GET /clients/1/invoices/1/old_error_logs/1 or /clients/1/invoices/1/old_error_logs/1.json
  def index
    render(partial: 'client/invoice/old_error_logs/table', locals: { old_error_logs: @old_error_logs })
  end

  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client_invoice_old_error_log
    @old_error_log = @invoice.old_error_logs.find(params[:id])
  end

  def set_client_invoice
    @invoice = @client.invoices.find(params[:invoice_id])
  end

  def set_client
    @client = Client.find(params[:client_id])
  end

  # Only allow a list of trusted parameters through.
  def client_invoice_old_error_log_params
    params.require(:client_invoice_old_error_log).permit(:client_invoice_id, :retry_number, :date, :log)
  end

  def set_old_error_logs
    @old_error_logs = @invoice.old_error_logs.all
    sort_old_error_logs
    @pagy, @old_error_logs = pagy(@old_error_logs)
  end

  def allow_sort
    %w[id retry_number date].include?(params[:sort_by].to_s)
  end

  def sort_old_error_logs
    return unless allow_sort

    sort = { params[:sort_by].to_sym => params[:sort_order] == 'DESC' ? 'DESC' : 'ASC' }

    @old_error_logs = @old_error_logs.order(sort)
  end
end
