# frozen_string_literal: true

class UserSessionsController < ApplicationController
  before_action :redirect_already_logged, only: %i[login authenticate]
  def login; end

  def authenticate
    user = User.find_by(email: params[:user][:email])

    if user&.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:alert] = 'Login failed'
      render login_path
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
