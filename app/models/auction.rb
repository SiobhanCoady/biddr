class Auction < ApplicationRecord
  has_many :bids, dependent: :destroy
  belongs_to :user

  validates(:title, { presence: true,
                      uniqueness: true })
  validates(:details, { presence: true, length: { minimum: 5 } })
  validates(:ends_on, { presence: true })
  validates(:reserve_price, { presence: true })
  validates(:current_price, { presence: true,
                              numericality: { greater_than: 0 } })
  validates(:user_id, { presence: true })

  after_initialize :set_defaults

  private

    def set_defaults
      self.current_price ||= 1
    end

end
