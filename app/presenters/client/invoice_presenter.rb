# frozen_string_literal: true

class Client::InvoicePresenter < SimpleDelegator
  def self.status_options
    Client::Invoice.statuses.map do |name|
      [name[0].humanize, name[0]]
    end
  end
end
