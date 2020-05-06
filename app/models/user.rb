# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  extend Devise::Models
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  ROLES = {
    contractor: 'Contractor',
    appraiser: 'Appraiser',
    donor: 'Donor',
    buyer: 'Buyer',
    real_estate_agent: 'Real Estate Agent'
  }

  has_many :projects
  has_many :sales
  has_many :activities, dependent: :destroy
  has_many :wishlists
  has_many :orders

  has_one_attached :image
  has_one :favourite

  validate :roles_consistency
  scope :where_roles_contains, -> (role) { where("roles @> ?", "{#{role}}") }

  before_create do |user|
    user.client_code = user.generate_client_code
  end

  before_save :sanitize_array_input

  def to_s
    "#{firstname} #{lastname} - #{client_code}"
  end

  def generate_client_code
    loop do
      client_code = SecureRandom.hex(8)
      break client_code unless User.exists?(client_code: client_code)
    end
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def reset_password!(password, password_confirmation)
    self.reset_password_token = nil
    self.password = password
    self.password_confirmation = password_confirmation
    save
  end

  def self.ransackable_scopes(*)
    %i(where_roles_contains)
  end

  def titleize_roles
    roles.collect(&:titleize)
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end

  def sanitize_array_input
    self.roles = roles.reject(&:blank?)
  end


  def roles_consistency
    errors.add(:role, 'is not valid.') unless ROLES.values.include?(roles)
  end
end
