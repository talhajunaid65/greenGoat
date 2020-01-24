class AdminUser < ApplicationRecord
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  enum role: [:admin, :pm, :appraiser, :contractor]

  has_many :created_notes, class_name: 'Note', foreign_key: 'created_by_id'
end
