class Auction < ApplicationRecord
  has_many :bids, dependent: :destroy

  validates(:title, { presence: true,
                      uniqueness: true })
  validates(:details, { presence: true, length: { minimum: 5 } })
  validates(:ends_on, { presence: true })
  validates(:reserve_price, { presence: true })
end
