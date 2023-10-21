# frozen_string_literal: true

class ClientPresenter < SimpleDelegator
  def self.document_type_options
    Client.document_types.keys.map { |dc| [dc.upcase, dc] }
  end
end
