# frozen_string_literal: true

class PaymentType
  REDIS = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/1') }.freeze

  def self.integrations
    PaymentIntegration.constants.map do |constant_name|
      constant = PaymentIntegration.const_get(constant_name)
      next unless constant.is_a?(Class) && constant_name != 'Base'

      name_with_underscores = constant_name.to_s.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
      {
        name: name_with_underscores,
        class: constant
      }
    end.compact
  end

  def self.store
    redis = ::Redis.new(PaymentType.const_get(:REDIS))
    redis.set('payment_integration_classes', PaymentType.integrations.to_json)
  end

  def self.load
    redis = ::Redis.new(PaymentType.const_get(:REDIS))
    JSON.parse(redis.get('payment_integration_classes'))
  end

  def integrations
    @integrations ||= PaymentType.load
  end

  def integration_names
    @integration_names ||= integrations.map { |integration| integration['name'] }
  end

  def integration_by(name:)
    integrations.find do |integration|
      integration['name'] == name
    end
  end

  def clean
    @integrations = @integration_names = nil
  end
end
