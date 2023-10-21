# frozen_string_literal: true

class PaymentTypePresenter < SimpleDelegator
  def self.integration_options
    PaymentType.new.integration_names.map do |name|
      [name.humanize, name]
    end
  end
end
