# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :authenticate_user
  before_action :set_clients, only: %i[index list]
  before_action :set_client, only: %i[show edit update destroy]

  # GET /clients or /clients.json
  def index; end

  # GET /clients/1 or /clients/1.json
  def show; end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit; end

  # POST /clients or /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        flash[:success] = 'Client was successfully created.'
        format.html { redirect_to client_url(@client) }
        format.json { render :show, status: :created, location: @client }
      else
        flash[:error] = 'Client not created.'
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to client_url(@client), notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        flash[:error] = 'Client not updated.'
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    respond_to do |format|
      if @client.destroy
        flash[:success] = 'Client was successfully destroyed.'
      else
        flash[:error] = 'Client not destroyed.'
      end
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

  def list
    render(partial: 'clients/table', locals: { clients: @clients, is_report: false })
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.require(:client).permit(:name, :document, :document_type, :payment_type, :payment_day, :plan_value)
  end

  def set_clients
    @clients = Client.all
    sort_clients
    @clients
  end

  def allow_sort
    %w[id name document document_type].include?(params[:sort_by].to_s)
  end

  def sort_clients
    return unless allow_sort

    sort = { params[:sort_by].to_sym => params[:sort_order] == 'DESC' ? 'DESC' : 'ASC' }

    @clients = @clients.order(sort)
  end
end
