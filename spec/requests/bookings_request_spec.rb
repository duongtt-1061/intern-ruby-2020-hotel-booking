require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  let(:category) {FactoryBot.create :category}
  let(:room) {FactoryBot.create :room, {category: category}}
  let(:user) {FactoryBot.create :user}
  let(:order) {FactoryBot.create :order, user: user,
                                         room: room,
                                         date_start: "2020-12-20",
                                         date_end: "2020-12-22"}
  let(:order_b) {FactoryBot.create :order, user: user,
                                             room: room,
                                             date_start: "2020-12-23",
                                             date_end: "2020-12-25"}
  let!(:booking) {FactoryBot.create :booking, room_id: room.id,
                                              order_id: order.id,
                                              date_start: order.date_start,
                                              date_end: order.date_end}
  let!(:booking_b) {FactoryBot.create :booking, room_id: room.id,
                                                order_id: order_b.id,
                                                date_start: order_b.date_start,
                                                date_end: order_b.date_end}

  describe "POST #check_room" do
    context "when room can booking" do
      before {post :check_room, xhr: true, params: {room_id: room.id,
                                                    date_start: "2020-12-26"}}

      it "assign a @status equal open" do
        expect(assigns(:status)).to eq Booking::STATUSES[:open]
      end
    end

    context "when room cannot booking" do
      before {post :check_room, xhr: true, params: {room_id: room.id,
                                                    date_start: "2020-12-22"}}

      it "assign a @status equal close" do
        expect(assigns(:status)).to eq Booking::STATUSES[:close]
      end
    end
  end
end
