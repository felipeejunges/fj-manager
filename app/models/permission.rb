# frozen_string_literal: true

class Permission < ApplicationRecord
  has_and_belongs_to_many :roles
end
