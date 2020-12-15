class Address < ApplicationRecord
  ADDRESS_PERMIT = %i(id location _destroy).freeze

  belongs_to :user

  validates :location, presence: true,
                       length: {maximum: Settings.model.validate.max_address}
end
