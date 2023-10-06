# frozen_string_literal: true

class RefreshPaymentTypeJob < ApplicationJob
  def perform(*_args)
    PaymentType.store
  end
end
