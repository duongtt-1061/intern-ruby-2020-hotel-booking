class Room < ApplicationRecord
  ROOM_PERMIT = [:name, :slug, :category_id, :price, :ward_id,
                 :max_person, :description, :map, :address, :pictures,
                 room_pictures_attributes: RoomPicture::ROOM_PICTURE].freeze

  belongs_to :category
  has_many :room_supplies, dependent: :destroy
  has_many :supplies, through: :room_supplies
  has_many :orders, dependent: :destroy
  has_many :room_pictures, dependent: :destroy
  mount_uploader :pictures, RoomPictureUploader
  accepts_nested_attributes_for :room_pictures, allow_destroy: true

  validates :name, :slug, :price,
            :description, :map, :address, presence: true
  validates :price, :max_person,
            numericality: {greater_than: Settings.rooms.min_num}
  validates :name,
            :address, :slug, length: {maximum: Settings.rooms.max_length_string}

  scope :search_end_price, (lambda do |price|
    where "price <= ?", price if price.present?
  end)
  scope :search_by_name, (lambda do |name|
    where "LOWER(name) LIKE ?", "%#{name.downcase}%" if name.present?
  end)
  scope :search_by_price, (lambda do |price|
    where "price <= ?", price if price.present?
  end)
  scope :search_start_price, (lambda do |price|
    where "price >= ?", price if price.present?
  end)

  scope :top_hired, ->{order hired: Settings.model.order.desc}
  scope :relate_room, (lambda do |category_id|
    where category_id: category_id if category_id.present?
  end)
  scope :random_room, ->{order "RAND()"}

  scope :order_by, (lambda do |order_key, order_type|
    order "#{order_key} #{order_type}" if order_type.present? &&
                                          order_key.present?
  end)

  delegate :name, to: :category, prefix: true
end
