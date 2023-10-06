# frozen_string_literal: true

class Client::InvoicesController < ApplicationController
  before_action :authenticate_user
  before_action :set_client
  before_action :set_invoice

  # GET /clients/1/invoices/1 or /clients/1/invoices/1.json
  def show; end

  def retry
    payment_type = payment_type_param[:payment_type]
    @invoice.payment_type = payment_type if payment_type.present?
    @invoice.status = :generating
    @invoice.max_retries += 10
    respond_to do |format|
      if @invoice.save
        ::GenerateInvoiceJob.perform_in(1,
                                        { 'client_id': @invoice.client_id,
                                          'date': @invoice.reference_date }.to_json)
        format.html { redirect_to client_invoice_path(@client, @invoice) }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = @client.invoices.find(params[:id] || params[:invoice_id])
  end

  def set_client
    @client = Client.find(params[:client_id])
  end

  # Only allow a list of trusted parameters through.
  def invoice_params
    params.require(:client_invoice).permit(:description, :payment_type, :reference_date, :status, :payed_date, :invoice_value, :client_id,
                                           :max_retries)
  end

  def payment_type_param
    params.require(:client_invoice)
  end
end
