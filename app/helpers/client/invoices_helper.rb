# frozen_string_literal: true

module Client::InvoicesHelper
  def self.status_options
    Client::Invoice.statuses.map do |name|
      [name[0].humanize, name[0]]
    end
  end
end
