class Client::PlansController < ApplicationController
  before_action :set_client_plan, only: %i[ show edit update destroy ]

  # GET /client/plans or /client/plans.json
  def index
    @client_plans = Client::Plan.all
  end

  # GET /client/plans/1 or /client/plans/1.json
  def show
  end

  # GET /client/plans/new
  def new
    @client_plan = Client::Plan.new
  end

  # GET /client/plans/1/edit
  def edit
  end

  # POST /client/plans or /client/plans.json
  def create
    @client_plan = Client::Plan.new(client_plan_params)

    respond_to do |format|
      if @client_plan.save
        format.html { redirect_to client_plan_url(@client_plan), notice: "Plan was successfully created." }
        format.json { render :show, status: :created, location: @client_plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /client/plans/1 or /client/plans/1.json
  def update
    respond_to do |format|
      if @client_plan.update(client_plan_params)
        format.html { redirect_to client_plan_url(@client_plan), notice: "Plan was successfully updated." }
        format.json { render :show, status: :ok, location: @client_plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client/plans/1 or /client/plans/1.json
  def destroy
    @client_plan.destroy

    respond_to do |format|
      format.html { redirect_to client_plans_url, notice: "Plan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_plan
      @client_plan = Client::Plan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_plan_params
      params.fetch(:client_plan, {})
    end
end
