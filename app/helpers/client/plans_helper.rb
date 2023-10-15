# frozen_string_literal: true

module Client::PlansHelper
  def self.plan_options
    Client::Plan.all.map do |plan|
      text = "#{plan.name.humanize} - #{plan.price} - #{plan.billable_period.humanize}"
      [text, plan.id]
    end
  end
end
