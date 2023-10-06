# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user
  before_action :set_user, only: %i[show edit update destroy]
  before_action :only_admin, only: %i[edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    @user = User.new(user_params.merge(password_params))

    respond_to do |format|
      if @user.save
        flash[:success] = 'User was successfully created.'
        format.html { redirect_to user_url(@user) }
        format.json { render :show, status: :created, location: @user }
      else
        flash[:error] = 'User not created'
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    all_params = user_params
    all_params.merge!(password_params) if password_params[:password].present? && password_params[:password_confirmation].present?
    respond_to do |format|
      if @user.update(all_params)
        flash[:success] = 'User was successfully updated.'
        format.html { redirect_to user_url(@user) }
        format.json { render :show, status: :ok, location: @user }
      else
        flash[:error] = 'User not updated'
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    respond_to do |_format|
      if @user.destroy
        flash[:success] = 'User was successfully destroyed.'
      else
        flash[:error] = 'User not deleted'
      end
    end
    format.html { redirect_to users_url }
    format.json { head :no_content }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def only_admin
    redirect users_path unless true
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
