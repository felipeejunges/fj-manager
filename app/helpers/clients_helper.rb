# frozen_string_literal: true

module ClientsHelper
  def self.document_type_options
    Client.document_types.keys.map { |dc| [dc.upcase, dc] }
  end
end
