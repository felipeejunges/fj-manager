# frozen_string_literal: true

class Role < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :permissions
end
