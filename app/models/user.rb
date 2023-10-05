# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password :password, validations: true

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  before_update :at_least_one_admin
  before_destroy :at_least_one_admin

  def at_least_one_admin
    User.where(admin: true).where.not(id:)
  end

  def name
    "#{first_name} #{last_name}"
  end
end
