class ItemVisit < ApplicationRecord
  belongs_to :product, optional: false
  belongs_to :user, optional: false
  belongs_to :created_by, class_name: 'AdminUser', foreign_key: 'admin_user_id', optional: false

  validates :contact_date, :visit_date, presence: true

  scope :due, -> { where(visit_date: Date.today) }
end
