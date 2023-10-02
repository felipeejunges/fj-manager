# frozen_string_literal: true

class Client::InvoicesController < ApplicationController
  before_action :set_client
  before_action :set_invoice, only: %i[show edit update destroy]

  # GET /clients/1/invoices/1 or /clients/1/invoices/1.json
  def show; end

  # GET /clients/1/invoices/new
  def new
    @invoice = @client.invoices.new
  end

  # GET /clients/1/invoices/1/edit
  def edit; end

  # POST /clients/1/invoices or /clients/1/invoices.json
  def create
    @invoice = @client.invoices.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to client_invoice_url(@client.id, @invoice), notice: 'Client invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1/invoices/1 or /clients/1/invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to invoice_url(@client.id, @invoice), notice: 'Client invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1/invoices/1 or /clients/1/invoices/1.json
  def destroy
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to client_path(@client), notice: 'Client invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = @client.invoices.find(params[:id])
  end

  def set_client
    @client = Client.find(params[:client_id])
  end

  # Only allow a list of trusted parameters through.
  def invoice_params
    params.require(:invoice).permit(:description, :payment_type, :reference_date, :payment_day, :status, :payed_date, :invoice_value, :client_id)
  end
end
