class Note < ApplicationRecord
  belongs_to :task
  belongs_to :created_by, class_name: 'AdminUser', foreign_key: 'created_by_id'
end
