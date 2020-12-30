require "rails_helper"

RSpec.describe Booking, type: :model do
  let(:category) {FactoryBot.create :category}
  let(:room) {FactoryBot.create :room, {category: category}}
  let(:user) {FactoryBot.create :user}
  let(:order) {FactoryBot.create :order, user: user,
                                         room: room}
  let(:booking) {FactoryBot.create :booking, room_id: room.id,
                                             order_id: order.id,
                                             date_start: "2020-12-24",
                                             date_end: order.date_end}

  describe "scopes" do
    it ".check_status_by_date" do
      expect(Booking.check_status_by_date("2020-12-24", "2020-12-26")).to eq [booking]
    end
  end
end
