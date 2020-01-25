class AdminUser < ApplicationRecord
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  enum role: [:admin, :pm, :appraiser, :contractor, :architect]

  has_many :created_notes, class_name: 'Note', foreign_key: 'created_by_id'

  scope :pms, -> { where(role: 1) }
  scope :appraisers, -> { where(role: 2) }
  scope :contractors, -> { where(role: 3) }
  scope :architects, -> { where(role: 4) }

  def to_s
    [first_name, last_name].join(' ')
  end
end
