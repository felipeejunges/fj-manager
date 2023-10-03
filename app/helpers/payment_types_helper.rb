# frozen_string_literal: true

module PaymentTypesHelper
  def self.integration_options
    PaymentType.new.integration_names.map do |name|
      [name.humanize, name]
    end
  end
end
