# frozen_string_literal: true

class Client::PlansController < ApplicationController
  before_action :redirect_if_not_admin, only: %i[edit update destroy]
  before_action :set_client_plans, only: %i[index list]
  before_action :set_client_plan, only: %i[show edit update destroy]

  # GET /client/plans or /client/plans.json
  def index; end

  def list
    render(partial: 'client/plans/table', locals: { client_plans: @client_plans })
  end

  # GET /client/plans/1 or /client/plans/1.json
  def show
    @pagy, @client_plan.clients = pagy(@client_plan.clients)
  end

  # GET /client/plans/new
  def new
    @client_plan = Client::Plan.new
  end

  # GET /client/plans/1/edit
  def edit; end

  # POST /client/plans or /client/plans.json
  def create
    @client_plan = Client::Plan.new(client_plan_params)

    respond_to do |format|
      if @client_plan.save
        flash[:success] = 'Plan was successfully created.'
        format.html { redirect_to client_plan_url(@client_plan), notice: 'Plan was successfully created.' }
      else
        flash[:error] = 'Plan not created.'
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /client/plans/1 or /client/plans/1.json
  def update
    respond_to do |format|
      if @client_plan.update(client_plan_params)
        format.html { redirect_to client_plan_url(@client_plan), notice: 'Plan was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client/plans/1 or /client/plans/1.json
  def destroy
    respond_to do |format|
      if @client_plan.destroy
        flash[:success] = 'Plan was successfully destroyed.'
      else
        flash[:error] = 'Plan not deleted'
      end
      format.html { redirect_to client_plans_url }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client_plan
    @client_plan = Client::Plan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def client_plan_params
    params.require(:client_plan).permit(:name, :description, :price, :signable,
                                        :start_date, :end_date, :billable_period,
                                        :max_discount, :commissionable, :sale, :code)
  end

  def set_client_plans
    @client_plans = Client::Plan.all
    sort_client_plans
    @pagy, @client_plans = pagy(@client_plans)
  end

  def allow_sort
    %w[id name price start_date end_date].include?(params[:sort_by].to_s)
  end

  def sort_client_plans
    return unless allow_sort

    sort = { params[:sort_by].to_sym => params[:sort_order] == 'DESC' ? 'DESC' : 'ASC' }

    @client_plans = @client_plans.order(sort)
  end
end
