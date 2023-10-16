# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client::Invoice::ErrorLog, type: :model do
  describe 'scopes' do
    let!(:error_log_this_year) { create(:client_invoice_error_log, date: Date.current) }
    let!(:error_log_last_year) { create(:client_invoice_error_log, date: 1.year.ago) }
    let!(:error_log_this_month) { create(:client_invoice_error_log, date: Date.current) }
    let!(:error_log_last_month) { create(:client_invoice_error_log, date: 1.month.ago) }

    it 'filters records for the current year' do
      logs_this_year = Client::Invoice::ErrorLog.range_year(Date.current)
      logs_last_year = Client::Invoice::ErrorLog.range_year(1.year.ago)

      expect(logs_this_year).to include(error_log_this_year)
      expect(logs_this_year).not_to include(error_log_last_year)
      expect(logs_last_year).to include(error_log_last_year)
      expect(logs_last_year).not_to include(error_log_this_year)
    end

    it 'filters records for the current month' do
      logs_this_month = Client::Invoice::ErrorLog.range_month(Date.current)
      logs_last_month = Client::Invoice::ErrorLog.range_month(1.month.ago)

      expect(logs_this_month).to include(error_log_this_month)
      expect(logs_this_month).not_to include(error_log_last_month)
      expect(logs_last_month).to include(error_log_last_month)
      expect(logs_last_month).not_to include(error_log_this_month)
    end
  end
end
