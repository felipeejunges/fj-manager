# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :invoices, class_name: 'Client::Invoice', inverse_of: :client
  has_many :error_logs, through: :invoices

  enum document_type: {
    cnpj: 1,
    cpf: 2
  }
end
