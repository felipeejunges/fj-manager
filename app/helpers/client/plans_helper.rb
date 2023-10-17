# frozen_string_literal: true

module Client::PlansHelper
  def self.plan_options
    Client::Plan.all.map do |plan|
      text = "#{plan.name.humanize} - #{plan.price} - #{plan.billable_period.humanize}"
      [text, plan.id]
    end
  end

  def self.billable_period_options
    Client::Plan.billable_periods.map do |name|
      [name[0].humanize, name[0]]
    end
  end
end
