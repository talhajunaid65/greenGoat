class AdminUser < ApplicationRecord
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  enum role: [:admin, :pm, :appraiser, :contractor, :architect]

  has_many :created_notes, class_name: 'Note', foreign_key: 'created_by_id'

  def to_s
    [first_name, last_name].join(' ')
  end
end
