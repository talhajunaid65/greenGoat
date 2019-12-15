class Project < ApplicationRecord
	belongs_to :user
	has_many :tasks
	has_many :products
	accepts_nested_attributes_for :tasks, :allow_destroy => true
	# validates :address, :presence => true, :uniqueness => true
	enum type_of_project: [:gut, :full, :kitchen, :other]
	enum status: [:not_pursuing, :appraisal_notes, :propsal, :contract]
end
