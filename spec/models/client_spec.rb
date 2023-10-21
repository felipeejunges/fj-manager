# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do # rubocop:disable Metrics/BlockLength
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:document) }
    it { should validate_presence_of(:document_type) }
    it { should validate_presence_of(:payment_type) }
    it { should validate_presence_of(:payment_day) }
    it { should validate_presence_of(:discount) }
  end

  describe 'associations' do
    it { should have_many(:invoices).class_name('Client::Invoice').dependent(:destroy) }
  end

  describe 'enums' do
    it { should define_enum_for(:document_type).with_values(cnpj: 1, cpf: 2) }
  end

  describe 'methods' do # rubocop:disable Metrics/BlockLength
    let(:client) { create(:client, created_at: Time.zone.parse('2022-01-01')) }
    let(:plan_price) { client.plan.price }

    it 'calculates net values correctly' do
      expect(client.net_value).to eq(plan_price - ((plan_price * client.discount) / 100))
    end

    it 'calculates expected earnings this year' do
      create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :payed)
      create(:client_invoice, client:, invoice_value: 1500, reference_date: 1.month.ago, status: :payed)
      expected_earnings_this_year = 1000 + 1500 + (client.net_value * 10)
      expect(client.expected_earnings_this_year).to eq(expected_earnings_this_year)
    end

    it 'calculates current status' do
      create(:client_invoice, client:, status: 'payed', reference_date: Date.current)
      create(:client_invoice, client:, status: 'generating', reference_date: 1.month.ago)
      create(:client_invoice, client:, status: 'error', reference_date: 2.month.ago)

      expect(client.current_status).to eq('payed')
    end

    it 'calculates expected earnings comparisson yearly correctly' do
      create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :payed)
      create(:client_invoice, client:, invoice_value: 1500, reference_date: 1.month.ago, status: :payed)
      expected_earnings_this_year = 1000 + 1500 + (client.net_value * 10)

      earnings_last_year = client.earnings_last_year

      expected_comparisson = client.calculate_percentage_difference(earnings_last_year, expected_earnings_this_year)

      expect(client.expected_earnings_comparisson_yearly).to eq(expected_comparisson)
    end

    it 'calculates earnings for the current year correctly' do
      create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :payed)
      create(:client_invoice, client:, invoice_value: 1500, reference_date: 1.month.ago, status: :payed)
      earnings_this_year = 1000 + 1500

      expect(client.earnings_this_year).to eq(earnings_this_year)
    end

    it 'calculates earnings for the last year correctly' do
      create(:client_invoice, client:, invoice_value: 1000, reference_date: 1.year.ago, status: :payed)
      earnings_last_year = 1000

      expect(client.earnings_last_year).to eq(earnings_last_year)
    end

    it 'calculates earnings comparisson yearly correctly' do
      earnings_this_year = client.earnings_this_year
      earnings_last_year = client.earnings_last_year

      expected_comparisson = client.calculate_percentage_difference(earnings_last_year, earnings_this_year)

      expect(client.earnings_comparisson_yearly).to eq(expected_comparisson)
    end

    it 'calculates errors for the current year correctly' do
      invoice = create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :error)
      create(:client_invoice_error_log, client_invoice_id: invoice.id, date: Date.current)
      errors_this_year = 1

      expect(client.errors_this_year).to eq(errors_this_year)
    end

    it 'calculates errors for the last year correctly' do
      invoice = create(:client_invoice, client:, invoice_value: 1000, reference_date: 1.year.ago, status: :error)
      create(:client_invoice_error_log, client_invoice_id: invoice.id, date: 1.year.ago)
      errors_last_year = 1

      expect(client.errors_last_year).to eq(errors_last_year)
    end

    it 'calculates errors comparisson yearly correctly' do
      invoice = create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :error)
      create(:client_invoice_error_log, client_invoice_id: invoice.id, date: Date.current)
      invoice_last_year = create(:client_invoice, client:, invoice_value: 1000, reference_date: 1.year.ago, status: :payed)
      create(:client_invoice_error_log, client_invoice_id: invoice_last_year.id, date: 1.year.ago)
      create(:client_invoice_error_log, client_invoice_id: invoice_last_year.id, date: 1.year.ago)
      errors_this_year = 1
      errors_last_year = 2

      expected_comparisson = client.calculate_percentage_difference(errors_last_year, errors_this_year)

      expect(client.errors_comparisson_yearly).to eq(expected_comparisson)
    end

    it 'calculates generated invoices for the current year correctly' do
      create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :generated)
      generated_invoices_this_year = 1
      expect(client.generated_invoices_this_year).to eq(generated_invoices_this_year)
    end

    it 'calculates generated invoices for the last year correctly' do
      create(:client_invoice, client:, invoice_value: 1000, reference_date: 1.year.ago, status: :generated)
      generated_invoices_last_year = 1

      expect(client.generated_invoices_last_year).to eq(generated_invoices_last_year)
    end

    it 'calculates generated invoices comparisson yearly correctly' do
      create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :generated)
      create(:client_invoice, client:, invoice_value: 1000, reference_date: 1.year.ago, status: :generated)
      generated_invoices_this_year = 1
      generated_invoices_last_year = 1

      expected_comparisson = client.calculate_percentage_difference(generated_invoices_last_year, generated_invoices_this_year)

      expect(client.generated_invoices_comparisson_yearly).to eq(expected_comparisson)
    end

    it 'calculates earnings for the current month correctly' do
      create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :payed)
      earnings_this_month = 1000

      expect(client.earnings_this_month).to eq(earnings_this_month)
    end

    it 'calculates earnings for the last month correctly' do
      create(:client_invoice, client:, invoice_value: 500, reference_date: 1.month.ago, status: :payed)
      earnings_last_month = 500

      expect(client.earnings_last_month).to eq(earnings_last_month)
    end

    it 'calculates earnings comparisson monthly correctly' do
      create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :payed)
      create(:client_invoice, client:, invoice_value: 500, reference_date: 1.year.ago, status: :payed)
      earnings_this_month = 1000
      earnings_last_month = 500

      expected_comparisson = client.calculate_percentage_difference(earnings_last_month, earnings_this_month)

      expect(client.earnings_comparisson_monthly).to eq(expected_comparisson)
    end

    it 'calculates errors for the current month correctly' do
      invoice = create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :error)
      create(:client_invoice_error_log, client_invoice_id: invoice.id, date: Date.current)
      errors_this_month = 1

      expect(client.errors_this_month).to eq(errors_this_month)
    end

    it 'calculates errors for the last month correctly' do
      invoice_last_year = create(:client_invoice, client:, invoice_value: 1000, reference_date: 1.month.ago, status: :payed)
      create(:client_invoice_error_log, client_invoice_id: invoice_last_year.id, date: 1.month.ago)
      errors_last_month = 1

      expect(client.errors_last_month).to eq(errors_last_month)
    end

    it 'calculates errors comparisson monthly correctly' do
      invoice = create(:client_invoice, client:, invoice_value: 1000, reference_date: Date.current, status: :error)
      create(:client_invoice_error_log, client_invoice_id: invoice.id, date: Date.current)
      invoice_last_year = create(:client_invoice, client:, invoice_value: 1000, reference_date: 1.month.ago, status: :payed)
      create(:client_invoice_error_log, client_invoice_id: invoice_last_year.id, date: 1.month.ago)
      create(:client_invoice_error_log, client_invoice_id: invoice_last_year.id, date: 1.month.ago)
      errors_this_month = 1
      errors_last_month = 2

      expected_comparisson = client.calculate_percentage_difference(errors_last_month, errors_this_month)

      expect(client.errors_comparisson_monthly).to eq(expected_comparisson)
    end
  end
end

# == Schema Information
#
# Table name: clients
#
#  id               :integer          not null, primary key
#  name             :string
#  document         :string
#  document_type    :integer
#  payment_type     :string
#  payment_day      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  discount         :float            default(0.0)
#  email            :string
#  next_payment_day :integer
#  client_plan_id   :integer
#  created_by_id    :integer
#
# Foreign Keys
#
#  client_plan_id  (client_plan_id => client_plans.id)
#  created_by_id   (created_by_id => users.id)
#
