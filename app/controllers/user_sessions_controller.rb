# frozen_string_literal: true

class UserSessionsController < ApplicationController
  skip_before_action :authenticate_user
  before_action :redirect_already_logged, only: %i[login authenticate]
  def login; end

  def authenticate
    user = User.find_by(email: params[:user][:email])

    respond_to do |format|
      if user&.authenticate(params[:user][:password])
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{current_user.name}"
        format.html { redirect_to root_path }
      else
        flash[:alert] = 'Invalid email or password'
        format.html { render :login, status: :unprocessable_entity }
      end
    end
  end

  def logout
    session[:user_id] = nil
    @current_user = nil

    redirect_to login_path
  end

  private

  def redirect_already_logged
    return if current_user.blank?

    redirect_to '/'
  end
end
