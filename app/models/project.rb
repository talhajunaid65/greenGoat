class Project < ApplicationRecord
	belongs_to :user
	# validates :address, :presence => true, :uniqueness => true
	enum type_of_project: [:gut, :full, :kitchen, :other]
end
