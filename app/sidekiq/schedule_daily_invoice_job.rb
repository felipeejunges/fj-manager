# frozen_string_literal: true

class ScheduleDailyInvoiceJob < ApplicationJob
  def perform(args = '{}')
    args = JSON.parse(args)
    date = if args.present? && args['date'].present?
             Date.parse(args['date'])
           else
             Date.current.yesterday
           end

    Client.select(:id).where(payment_day: days(date)).pluck(:id).map do |id|
      next if client.plan.billable_period == :never

      ::GenerateInvoiceJob.perform_at(1, { 'client_id': id, date: }.to_json)
    end
  end

  def days(date)
    day = date.day
    return day unless day >= 28
    return day unless day >= Time.days_in_month(date.month, date.year)

    [28, 29, 30, 31].select { |d| d >= day }
  end
end
