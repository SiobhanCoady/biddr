class User < ApplicationRecord
  has_many :bids, dependent: :nullify
  has_many :auctions, dependent: :nullify

  has_many :trackings, dependent: :destroy
  has_many :tracked_auctions, through: :trackings, source: :auction

  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: VALID_EMAIL_REGEX

  before_validation :downcase_email

  private

    def downcase_email
      self.email.downcase! if email.present?
    end
end
