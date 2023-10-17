# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentType do # rubocop:disable Metrics/BlockLength
  describe '.integrations' do
    it 'returns a list of payment integrations' do
      integrations = PaymentType.integrations
      expect(integrations).to be_an(Array)
      expect(integrations).not_to be_empty
    end
  end

  describe '.store' do
    it 'stores payment integrations in Redis' do
      allow(::Redis).to receive(:new).and_return(redis_instance = instance_double(Redis))
      expect(redis_instance).to receive(:set).with('payment_integration_classes', anything)
      PaymentType.store
    end
  end

  describe '.load' do
    it 'loads payment integrations from Redis' do
      allow(::Redis).to receive(:new).and_return(redis_instance = instance_double(Redis))
      expect(redis_instance).to receive(:get).with('payment_integration_classes').and_return('[]')
      integrations = PaymentType.load
      expect(integrations).to be_an(Array)
      expect(integrations).to be_empty
    end
  end

  describe '#integration_names' do
    it 'returns an array of integration names' do
      allow(::Redis).to receive(:new).and_return(redis_instance = instance_double(Redis))
      expect(redis_instance).to receive(:get)
        .with('payment_integration_classes')
        .and_return('[{"name":"credit_card","class":"PaymentIntegration::CreditCard"}]')
      payment_type = PaymentType.new
      expect(payment_type.integration_names).to eq(['credit_card'])
    end
  end

  describe '#integration_by' do
    it 'returns integration details by name' do
      allow(::Redis).to receive(:new).and_return(redis_instance = instance_double(Redis))
      expect(redis_instance).to receive(:get)
        .with('payment_integration_classes')
        .and_return('[{"name":"credit_card","class":"PaymentIntegration::CreditCard"}]')
      payment_type = PaymentType.new
      integration = payment_type.integration_by(name: 'credit_card')
      expect(integration).to be_a(Hash)
      expect(integration['name']).to eq('credit_card')
      expect(integration['class']).to eq('PaymentIntegration::CreditCard')
    end
  end

  describe '#clean' do
    it 'resets integrations and integration_names' do
      payment_type = PaymentType.new
      payment_type.instance_variable_set(:@integrations, [1, 2, 3])
      payment_type.instance_variable_set(:@integration_names, ['integration'])
      payment_type.clean
      expect(payment_type.instance_variable_get(:@integrations)).to be_nil
      expect(payment_type.instance_variable_get(:@integration_names)).to be_nil
    end
  end

  describe '#class_from_integration_by' do
    it 'returns the class corresponding to the given integration name' do
      allow(::Redis).to receive(:new).and_return(redis_instance = instance_double(Redis))
      expect(redis_instance).to receive(:get)
        .with('payment_integration_classes')
        .and_return('[{"name":"credit_card","class":"PaymentIntegration::CreditCard"}]')

      payment_type = PaymentType.new
      integration_class = payment_type.class_from_integration_by(name: 'credit_card')
      expect(integration_class).to eq(PaymentIntegration::CreditCard.to_s)
    end

    it 'returns nil if integration class is not found' do
      allow(::Redis).to receive(:new).and_return(redis_instance = instance_double(Redis))
      expect(redis_instance).to receive(:get)
        .with('payment_integration_classes')
        .and_return('[{"name":"invalid_integration","class":"NonExistentIntegration"}]')

      payment_type = PaymentType.new
      integration_class = payment_type.class_from_integration_by(name: 'credit_card')
      expect(integration_class).to be_nil
    end
  end

  describe '#payment_check' do
    it 'returns the PAYMENT_CHECK constant from the specified integration class' do
      allow(::Redis).to receive(:new).and_return(redis_instance = instance_double(Redis))
      expect(redis_instance).to receive(:get)
        .with('payment_integration_classes')
        .and_return('[{"name":"credit_card","class":"PaymentIntegration::CreditCard"}]')

      payment_type = PaymentType.new
      payment_check = payment_type.payment_check(name: 'credit_card')
      expect(payment_check).to eq(PaymentIntegration::CreditCard::PAYMENT_CHECK)
    end

    it 'returns nil if integration class is not found' do
      allow(::Redis).to receive(:new).and_return(redis_instance = instance_double(Redis))
      expect(redis_instance).to receive(:get)
        .with('payment_integration_classes')
        .and_return('[{"name":"invalid_integration","class":"NonExistentIntegration"}]')

      payment_type = PaymentType.new
      payment_check = payment_type.payment_check(name: 'credit_card')
      expect(payment_check).to be_nil
    end
  end
end
