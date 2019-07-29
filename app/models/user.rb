# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :boards

  validates_presence_of :name, :email, :password, :password_confirmation
  validates_uniqueness_of :email
  validates :password, confirmation: true
end
