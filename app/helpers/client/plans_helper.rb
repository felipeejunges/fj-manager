# frozen_string_literal: true

module Client::PlansHelper
  def self.plan_options
    Client::Plan.all.map do |plan|
      [plan.name.humanize, plan.id]
    end
  end
end
