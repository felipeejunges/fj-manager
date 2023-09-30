# frozen_string_literal: true

class PaymentIntegration::Base
  def perform(*_args)
    integrate
    # schedule PaymentCheck
  end

  private

  def integrate; end
end
