# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  private

  def authenticate_user
    return if current_user.present?

    redirect_to '/login'
  end
end
