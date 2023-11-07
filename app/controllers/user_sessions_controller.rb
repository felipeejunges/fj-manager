# frozen_string_literal: true

class UserSessionsController < ApplicationController
  skip_before_action :require_login
  before_action :redirect_already_logged, only: %i[signin authenticate]
  def signin; end

  def authenticate
    respond_to do |format|
      format.html do
        user = login(params[:user][:email], params[:user][:password])
        if user
          flash[:success] = "Welcome, #{current_user.name}"
          redirect_to root_path
        else
          flash[:alert] = 'Invalid email or password'
          render :signin, status: :unprocessable_entity
        end
      end
      format.json do
        token = login_and_issue_token(params[:user][:email], params[:user][:password])
        if token
          render json: {
            token:
          }
        else
          render json: { error: 'Invalid email or password' }, status: :unprocessable_entity
        end
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
