class User < ApplicationRecord
  USER_PERMIT = [:name,
                 :email,
                 :password,
                 :password_confirmation,
                 addresses_attributes: Address::ADDRESS_PERMIT].freeze

  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :addresses,
                                reject_if: :all_blank,
                                allow_destroy: true

  validates :name, presence: true,
                   length: {maximum: Settings.model.validate.max_name_user}
  validates :email, presence: true,
                    length: {maximum: Settings.model.validate.max_email_user},
                    format: {with: Settings.model.validate.valid_email_regex},
                    uniqueness: true
  validates :password, presence: true,
                       length: {minimum: Settings.model.validate.min_password},
                       allow_nil: true
  enum role: {user: 0, admin: 1}
  has_secure_password
end
