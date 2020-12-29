class Order < ApplicationRecord
  ORDER_PARAMS = [
    :note,
    :room_id,
    :date_start,
    :date_end,
    :quantity_person,
    :price,
    :status,
    booking_attributes: Booking::BOOKING_PARAMS
  ].freeze

  ORDER_CHANGE_STATUS_PERMIT = :status

  belongs_to :user
  belongs_to :room
  has_one :booking, dependent: :destroy

  validates :date_start, :date_end, presence: true
  validate :validate_date_booking
  validates :quantity_person, numericality: {only_integer: true}
  validates :note, length: {maximum: Settings.model.validate.max_length_note}

  delegate :name, :address, :price, :max_person, :id, to: :room, prefix: true
  delegate :name, to: :user, prefix: true

  accepts_nested_attributes_for :booking,
                                reject_if: :all_blank,
                                allow_destroy: true

  scope :order_id_desc, ->{order id: :desc}
  scope :order_status_asc, ->{order status: :asc}
  scope :order_by, (lambda do |order_key, order_type|
    order "#{order_key} #{order_type}" if order_type.present? &&
                                          order_key.present?
  end)
  scope :by_id, (lambda do |id|
    where(id: id) if id.present?
  end)
  scope :by_date_start, (lambda do |date_start|
    where "date_start >= ?", date_start if date_start.present?
  end)
  scope :by_date_end, (lambda do |date_end|
    where "date_end <= ?", date_end if date_end.present?
  end)
  scope :by_status, (lambda do |status|
    where(status: status) if status.present?
  end)
  scope :by_room, (lambda do |room_id|
    where(room_id: room_id) if room_id.present?
  end)
  scope :by_note, (lambda do |content|
    where "note LIKE ?", "%#{content}%" if content.present?
  end)

  enum status: {pendding: 0, approved: 1, disapprove: 2, cancel: 3}

  ransacker :created_at do
    Arel.sql("date(created_at)")
  end

  def send_mail_create_order
    OrderMailer.create_order(user, self).deliver_now
  end

  def validate_date_booking
    return if date_start.blank? || date_end.blank?

    return unless date_end < date_start

    errors.add(:date_end, I18n.t("date_end_must_after_date_start"))
  end

  def not_expire_to_destroy?
    ((DateTime.now.to_time - created_at.to_time) / 1.hour).to_i < 24
  end

  class << self
    def ransackable_attributes auth_object = nil
      if auth_object.eql? :admin
        super
      else
        super & %w(status date_start date_end created_at)
      end
    end

    def ransackable_scopes auth_object = nil
      if auth_object.eql? :admin
        %i(by_note)
      else
        []
      end
    end
  end
end
