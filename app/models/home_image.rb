class HomeImage < ApplicationRecord
	has_one_attached :image

  validate :attached_image

  def attached_image
    errors.add(:image, 'please attached a file') unless image.attached?
  end
end
