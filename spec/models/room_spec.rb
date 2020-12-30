require "rails_helper"

RSpec.describe Room, type: :model do
  let(:category) {FactoryBot.create :category}

  let(:room) {FactoryBot.create :room, name: "haha", category: category}

  let!(:room_two) do
    FactoryBot.create :room, category: category
  end

  let!(:room_three) do
    FactoryBot.create :room, category: category,
                             price: 500
  end

  describe "scopes" do
    it ".search_end_price" do
      expect(Room.search_end_price(400)).to eq [room_two]
    end

    it ".search_by_name" do
      expect(Room.search_by_name("haha")).to eq [room]
    end

    it ".search_by_price" do
      expect(Room.search_by_price(400)).to eq [room_two]
    end

    it ".search_start_price" do
      expect(Room.search_start_price(400)).to eq [room_three]
    end

    it ".relate_room" do
      expect(Room.relate_room(category.id)).to eq [room_two, room_three]
    end
  end
end
