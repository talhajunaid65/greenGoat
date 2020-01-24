class Task < ApplicationRecord
  has_many :notes

  accepts_nested_attributes_for :notes, allow_destroy: true
end
