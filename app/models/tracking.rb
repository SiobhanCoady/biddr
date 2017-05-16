class Tracking < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  validates :auction_id, uniqueness: {scope: :user_id}
end
