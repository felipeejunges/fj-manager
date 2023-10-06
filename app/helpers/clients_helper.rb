# frozen_string_literal: true

module ClientsHelper
  def self.document_type_options
    Client.document_types.keys.map { |dc| [dc.upcase, dc] }
  end

  def earnings_this_year
    Client::Invoice.payed.range_year(Time.now).sum(:invoice_value)
  end

  def earnings_last_year
    Client::Invoice.payed.range_year(Time.now.last_year).sum(:invoice_value)
  end

  def earnings_comparisson_yearly
    calculate_percentage_difference(earnings_last_month, earnings_this_year)
  end

  def errors_this_year
    Client::Invoice::ErrorLog.range_year(Time.now).count
  end

  def errors_last_year
    Client::Invoice::ErrorLog.range_year(Time.now.last_year).count
  end

  def errors_comparisson_yearly
    calculate_percentage_difference(errors_last_year, errors_this_year)
  end

  def generated_invoices_this_year
    Client::Invoice.range_year_generated(Time.now).count
  end

  def generated_invoices_last_year
    Client::Invoice.range_year_generated(Time.now.last_year).count
  end

  def generated_invoices_comparisson_yearly
    calculate_percentage_difference(generated_invoices_last_year, generated_invoices_this_year)
  end

  def generated_invoices_this_month
    Client::Invoice.range_month_generated(Time.now).count
  end

  def generated_invoices_last_month
    Client::Invoice.range_month_generated(Time.now.last_year).count
  end

  def generated_invoices_comparisson_monthly
    calculate_percentage_difference(generated_invoices_last_month, generated_invoices_this_month)
  end

  def earnings_this_month
    Client::Invoice.payed.range_month(Time.now).sum(:invoice_value)
  end

  def earnings_last_month
    Client::Invoice.payed.range_month(Time.now.last_month).sum(:invoice_value)
  end

  def earnings_comparisson_monthly
    calculate_percentage_difference(earnings_last_month, earnings_this_month)
  end

  def errors_this_month
    Client::Invoice::ErrorLog.range_month(Time.now).count
  end

  def errors_last_month
    Client::Invoice::ErrorLog.range_month(Time.now.last_month).count
  end

  def errors_comparisson_monthly
    calculate_percentage_difference(errors_last_month, errors_this_month)
  end

  def calculate_percentage_difference(number1, number2)
    return 100 if number1.zero? && number2.nonzero?
    return -100 if number2.zero? && number1.nonzero?
    return 0 if number2.zero? && number1.zero?

    difference = number2 - number1
    percentage_difference = (difference.to_f / number1) * 100
    percentage_difference.round(2)
  end
end
