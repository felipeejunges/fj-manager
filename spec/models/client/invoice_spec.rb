require 'rails_helper'

RSpec.describe Client::Invoice, type: :model do
  describe 'associations' do
    it { should belong_to(:client) }
    it { should have_many(:error_logs).class_name('Client::Invoice::ErrorLog').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:invoice_value) }
    it { should validate_presence_of(:payment_type) }
  end

  describe 'scopes' do
    date = Date.new(Date.today.year, 1, 1)
    let!(:invoice) { create(:client_invoice, status: :generated, reference_date: date) }
    let!(:late_invoice) { create(:client_invoice, status: :late, reference_date: date) }
    let!(:payed_invoice) { create(:client_invoice, status: :payed, reference_date: date) }
    let!(:old_invoice) { create(:client_invoice, status: :generated, reference_date: date.prev_month) }

    describe '.range_year_generated' do
      it 'returns invoices generated, late, and payed within the given year' do
        expect(Client::Invoice.range_year_generated(date).count).to eq(3)
      end
    end

    describe '.range_month_generated' do
      it 'returns invoices generated, late, and payed within the given month' do
        expect(Client::Invoice.range_month_generated(date).count).to eq(3)
      end
    end

    describe '.range_day_generated' do
      it 'returns invoices generated, late, and payed within the given day' do
        expect(Client::Invoice.range_day_generated(date).count).to eq(3)
      end
    end

    describe '.range_year' do
      it 'returns invoices within the given year' do
        year = Date.current.year
        expect(Client::Invoice.range_year(date).count).to eq(3)
      end
    end

    describe '.range_month' do
      it 'returns invoices within the given month' do
        expect(Client::Invoice.range_month(date).count).to eq(3)
      end
    end
  end

  describe 'methods' do
    let(:invoice) { create(:client_invoice) }

    describe '#will_retry?' do
      it 'returns true if error logs count is less than max_retries' do
        allow(invoice).to receive(:error_logs).and_return(double(count: invoice.max_retries - 1))
        expect(invoice.will_retry?).to be_truthy
      end

      it 'returns false if error logs count is equal to max_retries' do
        allow(invoice).to receive(:error_logs).and_return(double(count: invoice.max_retries))
        expect(invoice.will_retry?).to be_falsey
      end
    end

    describe '#wont_retry?' do
      it 'returns true if will_retry? is false' do
        allow(invoice).to receive(:will_retry?).and_return(false)
        expect(invoice.wont_retry?).to be_truthy
      end

      it 'returns false if will_retry? is true' do
        allow(invoice).to receive(:will_retry?).and_return(true)
        expect(invoice.wont_retry?).to be_falsey
      end
    end

    describe '#store_error' do
      it 'creates a new error log and schedules GenerateInvoiceJob when retries are allowed' do
        allow(invoice).to receive(:will_retry?).and_return(true)
        expect(::GenerateInvoiceJob).to receive(:perform_in).with(10, any_args)
        invoice.store_error(StandardError.new('Example error'))
        expect(invoice.error_logs.count).to eq(1)
      end

      it 'does not create a new error log and does not schedule GenerateInvoiceJob when retries are not allowed' do
        allow(invoice).to receive(:will_retry?).and_return(false)
        expect(::GenerateInvoiceJob).not_to receive(:perform_in)
        invoice.store_error(StandardError.new('Example error'))
        expect(invoice.error_logs.count).to eq(1)
      end
    end

    describe '#error_logs?' do
      it 'returns true if there are error logs' do
        create(:client_invoice_error_log, invoice: invoice)
        expect(invoice.error_logs?).to be_truthy
      end

      it 'returns false if there are no error logs' do
        expect(invoice.error_logs?).to be_falsey
      end
    end

    describe '#add_more_retries' do
      it 'increases max_retries by 10 and updates the record' do
        initial_retries = invoice.max_retries
        invoice.add_more_retries
        expect(invoice.max_retries).to eq(initial_retries + 10)
      end
    end
  end
end
