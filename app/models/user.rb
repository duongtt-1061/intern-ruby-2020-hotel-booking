class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
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
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
                       length: {minimum: Settings.model.validate.min_password},
                       allow_nil: true
  enum role: {user: 0, admin: 1}

  def self.from_omniauth auth
    result = User.find_by email: auth.info.email
    return result if result

    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.uid = auth.uid
      user.provider = auth.provider
      user.skip_confirmation!
    end
  end
end
