# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  after_initialize :set_default_role, :if => :new_record?

  has_many :projects
  has_many :sales

  has_one_attached :image
  has_one :wishlist

  def to_s
    "#{firstname} #{lastname} - #{client_code}"
  end
end
