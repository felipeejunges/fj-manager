# frozen_string_literal: true

class Client::InvoicesController < ApplicationController
  before_action :set_client
  before_action :set_invoice, only: %i[show retry]
  before_action :set_invoices, only: :index

  def index
    render(partial: 'client/invoices/table', locals: { invoices: @invoices })
  end

  # GET /clients/1/invoices/1 or /clients/1/invoices/1.json
  def show
    @pagy, @error_logs = pagy(@invoice.error_logs)
  end

  def retry
    payment_type = payment_type_param[:payment_type]
    @invoice.payment_type = payment_type if payment_type.present?
    @invoice.status = :generating
    @invoice.max_retries += 10
    respond_to do |format|
      if @invoice.save
        flash[:success] = 'Retry was successfully scheduled'
        ::GenerateInvoiceJob.perform_in(1,
                                        { 'client_id': @invoice.client_id,
                                          'date': @invoice.reference_date }.to_json)
        format.html { redirect_to client_invoice_path(@client, @invoice) }
      else
        flash[:error] = 'Retry not scheduled'
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = @client.invoices.find(params[:id] || params[:invoice_id])
    authorize @invoice
  end

  def set_client
    @client = Client.find(params[:client_id])
  end

  def payment_type_param
    params.require(:client_invoice)
  end

  def set_invoices
    authorize Client::Invoice

    @invoices = @client.invoices.all
    sort_invoices
    @pagy, @invoices = pagy(@invoices)
  end

  def allow_sort
    %w[id description payment_type reference_month status].include?(params[:sort_by].to_s)
  end

  def sort_invoices
    return unless allow_sort

    sort = { params[:sort_by].to_sym => params[:sort_order] == 'DESC' ? 'DESC' : 'ASC' }

    @invoices = @invoices.order(sort)
  end
end
