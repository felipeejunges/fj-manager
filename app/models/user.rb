# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password :password, validations: true

  has_many :created_clients, class_name: 'Client',
                             inverse_of: :created_by,
                             dependent: :destroy,
                             foreign_key: :created_by_id

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  before_update :at_least_one_admin
  before_destroy :at_least_one_admin

  def at_least_one_admin
    User.where(admin: true).where.not(id:)
  end

  def admin?
    admin
  end

  def name
    "#{first_name} #{last_name}"
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string
#  password_digest :string
#  admin           :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
