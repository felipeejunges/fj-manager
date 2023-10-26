# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit::Authorization

  before_action :require_login

  private

  def pagy_get_vars(collection, vars)
    pagy_set_items_from_params(vars) if defined?(ItemsExtra)
    count = collection.instance_of?(Mongoid::Criteria) ? collection.count : collection.count(:all)
    vars[:count] ||= count.is_a?(Hash) ? count.size : count
    vars[:page]  ||= params[vars[:page_param] || Pagy::DEFAULT[:page_param]]
    vars
  end

  def not_authenticated
    redirect_to '/login'
  end
end
