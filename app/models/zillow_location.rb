class ZillowLocation < ApplicationRecord
  belongs_to :user

  has_many :tasks
  has_many :products
  has_many :projects

  accepts_nested_attributes_for :tasks, :allow_destroy => true
  # validates :address, :presence => true, :uniqueness => true
  enum type_of_project: [:gut, :full, :kitchen, :other]
  enum status: [:not_pursuing, :appraisal_notes, :proposal, :contract]

  scope :type, ->(type_of_project) { where(type_of_project: type_of_project) }
  scope :in_zipcode, -> (zip) { where(zip: zip) }

  def to_s
    "#{address}, #{city} #{zip} #{state}"
  end
end
