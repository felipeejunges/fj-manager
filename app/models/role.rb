# frozen_string_literal: true

class Role < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :permissions

  validates :name, :code, presence: true
end

# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  code        :string
#  active      :boolean          default(TRUE)
#  deletable   :boolean          default(TRUE)
#  editable    :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
