# frozen_string_literal: true

class Permission < ApplicationRecord
  has_and_belongs_to_many :roles
end

# == Schema Information
#
# Table name: permissions
#
#  id          :integer          not null, primary key
#  key         :string
#  action      :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
