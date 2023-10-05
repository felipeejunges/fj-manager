# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def current_user
    @current_user ||= session[:user_id] && User.find_by(id: session[:user_id])
  end

  def authenticate_user
    return if current_user.present?

    redirect_to '/login'
  end
end
