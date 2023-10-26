# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!
  # has_secure_password :password, validations: true

  has_and_belongs_to_many :roles
  has_many :permissions, through: :roles

  has_many :created_clients, class_name: 'Client',
                             inverse_of: :created_by,
                             dependent: :destroy,
                             foreign_key: :created_by_id

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  before_update :at_least_one_admin
  before_destroy :at_least_one_admin

  def at_least_one_admin
    User.where(admin: true).where.not(id:)
  end

  def admin?
    roles.where(code: 'admin').present?
  end

  def name
    "#{first_name} #{last_name}"
  end
end

# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  first_name       :string
#  last_name        :string
#  email            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  crypted_password :string
#  salt             :string
#
