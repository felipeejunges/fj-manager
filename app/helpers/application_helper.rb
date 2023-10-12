# frozen_string_literal: true

module ApplicationHelper
  include ActionView::Helpers::NumberHelper
  include Pagy::Frontend

  def flash_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def sort_link(controller: nil, column: '', label: '', action: '', link: nil)
    link_to("#{label} #{sort_indicator(column:)}".html_safe, sort_link_hash(controller:, action:, column:, link:))
  end

  def sort_indicator(column:)
    indicator_class = params[:sort_order] == 'DESC' ? 'down' : 'up'
    klass = column.to_s == params[:sort_by].to_s ? "bi bi-sort-#{indicator_class}" : 'bi bi-filter-left'
    content_tag(:i, '', class: klass)
  end

  def sort_link_hash(controller: nil, column: '', action: '', link: nil)
    path = initialize_path(controller:, action:, link:)
    path.merge!(sort_by: column) if column.present?
    direction = params[:sort_order] == 'ASC' ? 'DESC' : 'ASC'
    params.each do |key, value|
      path.merge!(key.to_sym => value) if %i[sort_by sort_order controller action].exclude?(key.to_sym)
    end
    path.merge!(sort_order: direction)
    path
  end

  def initialize_path(controller:, action: '', link: nil)
    return Rails.application.routes.recognize_path(link) if link.present?

    path = { controller: }
    path.merge!(action:) if action.present?
    path
  end
end
