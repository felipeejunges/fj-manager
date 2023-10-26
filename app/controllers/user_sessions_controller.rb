# frozen_string_literal: true

class UserSessionsController < ApplicationController
  skip_before_action :require_login
  before_action :redirect_already_logged, only: %i[login authenticate]
  def signin; end

  def authenticate
    user = login(params[:user][:email], params[:user][:password])

    respond_to do |format|
      if user
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{current_user.name}"
        format.html { redirect_to root_path }
      else
        flash[:alert] = 'Invalid email or password'
        format.html { render :login, status: :unprocessable_entity }
      end
    end
  end

  def signout
    logout

    redirect_to login_path
  end

  private

  def redirect_already_logged
    return if current_user.blank?

    redirect_to '/'
  end
end
