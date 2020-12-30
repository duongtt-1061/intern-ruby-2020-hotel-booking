require "rails_helper"

RSpec.describe Order, type: :model do
  let(:category) {FactoryBot.create :category}
  let(:room) {FactoryBot.create :room, {category: category}}
  let(:user) {FactoryBot.create :user}
  let(:order) {FactoryBot.create :order, user_id: user.id,
                                         room_id: room.id,
                                         note: "haha",
                                         created_at: "2015-12-25"}
  let(:invalid_order) {FactoryBot.build :order, room_id: room.id}
  let!(:order_two) do
    FactoryBot.create :order, user_id: user.id,
                              room_id: room.id,
                              date_start: "2020-12-21",
                              date_end: "2020-12-25"
  end

  let!(:order_three) do
    FactoryBot.create :order, user_id: user.id,
                              room_id: room.id,
                              date_start: "2020-12-26",
                              date_end: "2020-12-30",
                              status: :approved
  end

  describe "validations" do
    it "valid all fields" do
      expect(order.valid?).to eq true
    end

    it "invalid any field" do
      expect(invalid_order.valid?).to eq false
    end
  end

  describe "Associations" do
    it "belong to user" do
      is_expected.to belong_to :user
    end

    it "belong to room" do
      is_expected.to belong_to :room
    end

    it {is_expected.to have_one :booking}
  end

  describe "nested attributes" do
    it "booking" do
      is_expected.to accept_nested_attributes_for(:booking).allow_destroy true
    end
  end

  describe "enums" do
    it "status" do
      is_expected.to define_enum_for(:status)
                 .with_values pendding: 0, approved: 1, disapprove: 2, cancel: 3
    end
  end

  describe "scopes" do
    it ".order_id_desc" do
      expect(Order.order_id_desc.pluck(:id)).to eq [order_three.id, order_two.id]
    end

    it ".order_status_asc" do
      expect(Order.order_status_asc.pluck(:status)).to eq [order_two.status, order_three.status]
    end

    it ".order_by field id asc" do
      expect(Order.order_by(:id, :asc).pluck(:id)).to eq [order_two.id, order_three.id]
    end

    it ".order_by field id desc" do
      expect(Order.order_by(:id, :desc).pluck(:id)).to eq [order_three.id, order_two.id]
    end

    it ".order_by field status asc" do
      expect(Order.order_by(:status, :asc).pluck(:status)).to eq [order_two.status, order_three.status]
    end

    it ".order_by field status desc" do
      expect(Order.order_by(:status, :desc).pluck(:status)).to eq [order_three.status, order_two.status]
    end

    it "find by id" do
      expect(Order.by_id(order_three.id)).to eq [order_three]
    end

    it ".by_date_start" do
      expect(Order.by_date_start("2020-12-24")).to eq [order_three]
    end

    it ".by_date_end" do
      expect(Order.by_date_end("2020-12-26")).to eq [order_two]
    end

    it ".by_status" do
      expect(Order.by_status(:pendding)).to eq [order_two]
    end

    it ".by_room" do
      expect(Order.by_room(order_two.room_id)).to eq [order_two, order_three]
    end

    it ".by_note" do
      expect(Order.by_note("ha")).to eq [order]
    end
  end

  describe "instance method" do
    it "should return false when order expired" do
      expect(order.not_expire_to_destroy?).to eq false
    end
  end
end
