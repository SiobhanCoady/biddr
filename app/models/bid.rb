class Bid < ApplicationRecord
  belongs_to :auction
  belongs_to :user

  validates(:amount, { presence: true })

  validate :minimum_bid

  private

    def minimum_bid
      # Cannot get this validation to catch
      amount > auction.current_price
      # if amount > auction.current_price
      #   errors.add(:amount, "Cannot be less than the current auction price")
      # end
    end
end
