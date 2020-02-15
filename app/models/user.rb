# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  enum role: {
    donor: 'donor',
    buyer: 'buyer'
  }

  after_initialize :set_default_role, :if => :new_record?

  has_many :projects
  has_many :sales

  has_one_attached :image
  has_one :wishlist

  before_create do |user|
    user.auth_token = user.generate_client_code
  end

  def set_default_role
    self.role ||= :buyer
  end

  def to_s
    "#{firstname} #{lastname} - #{client_code}"
  end

  def generate_client_code
    loop do
      client_code = SecureRandom.hex(3)
      break client_code unless User.exists?(client_code: client_code)
    end
  end
end
