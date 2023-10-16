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

  def pagy_get_vars(collection, vars)
    pagy_set_items_from_params(vars) if defined?(ItemsExtra)
    count = collection.instance_of?(Mongoid::Criteria) ? collection.count : collection.count(:all)
    vars[:count] ||= count.is_a?(Hash) ? count.size : count
    vars[:page]  ||= params[vars[:page_param] || Pagy::DEFAULT[:page_param]]
    vars
  end

  def redirect_if_not_admin
    return if current_user.admin?

    redirect_to '/'
  end
end
