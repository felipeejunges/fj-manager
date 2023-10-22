# frozen_string_literal: true

class Role < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :permissions
end

# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  code        :string
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
