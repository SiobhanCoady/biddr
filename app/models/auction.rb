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

  include AASM

  aasm whiny_transitions: false do
    state :draft, initial: true
    state :published
    state :reserve_met
    state :won
    state :cancelled
    state :reserve_not_met

    event :publish do
      transitions from: :draft, to: :published
    end

    event :meet_reserve do
      transitions from: :published, to: :reserve_met
    end

    event :win do
      transitions from: :reserve_met, to: :won
    end

    event :cancel do
      transitions from: [:published, :reserve_met, :won], to: :cancelled
    end

    event :not_meet_reserve do
      transitions from: :published, to: :reserve_not_met
    end

    event :reoffer do
      transitions from: :cancelled, to: :draft
    end
  end

  private

    def set_defaults
      self.current_price ||= 1
    end

end
