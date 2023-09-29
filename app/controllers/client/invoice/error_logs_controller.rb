# frozen_string_literal: true

class Client::Invoice::ErrorLogsController < ApplicationController
  before_action :set_client
  before_action :set_client_invoice
  before_action :set_client_invoice_error_log, only: %i[show edit update destroy]

  # GET /clients/1/invoices/1/error_logs or /clients/1/invoices/1/error_logs.json
  def index
    @error_logs = @invoice.error_logs.all
  end

  # GET /clients/1/invoices/1/error_logs/1 or /clients/1/invoices/1/error_logs/1.json
  def show; end

  # GET /clients/1/invoices/1/error_logs/new
  def new
    @error_log = @invoice.error_logs.new
  end

  # GET /clients/1/invoices/1/error_logs/1/edit
  def edit; end

  # POST /clients/1/invoices/1/error_logs or /clients/1/invoices/1/error_logs.json
  def create
    @error_log = @invoice.error_logs.new(client_invoice_error_log_params)

    respond_to do |format|
      if @error_log.save
        format.html do
          redirect_to client_invoice_error_log_url(@client.id, @invoice.id, @error_log), notice: 'Client invoice error log was successfully created.'
        end
        format.json { render :show, status: :created, location: @error_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @error_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1/invoices/1/error_logs/1 or /clients/1/invoices/1/error_logs/1.json
  def update
    respond_to do |format|
      if @error_log.update(client_invoice_error_log_params)
        format.html do
          redirect_to client_invoice_error_log_url(@client.id, @invoice.id, @error_log), notice: 'Client invoice error log was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @error_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @error_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1/invoices/1/error_logs/1 or /clients/1/invoices/1/error_logs/1.json
  def destroy
    @error_log.destroy

    respond_to do |format|
      format.html { redirect_to client_invoice_error_logs_url, notice: 'Client invoice error log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

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
