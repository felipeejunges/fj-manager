# frozen_string_literal: true

class Client::Invoice::ErrorLogsController < ApplicationController
  before_action :set_client
  before_action :set_client_invoice
  before_action :set_client_invoice_error_log

  # GET /clients/1/invoices/1/error_logs/1 or /clients/1/invoices/1/error_logs/1.json
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
end
