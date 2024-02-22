
class StylistRequest < ApplicationRecord
  # Validations
  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :stylist_id, presence: true, numericality: { only_integer: true }
  validates :request_details, presence: true

  # Associations
  belongs_to :user
  belongs_to :stylist, class_name: 'User', foreign_key: 'stylist_id'
end
