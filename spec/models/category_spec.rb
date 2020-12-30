require "rails_helper"

RSpec.describe Category, type: :model do
  let(:category) {FactoryBot.create :category}

  let(:room) {FactoryBot.create :room, category: category}

  describe "define function" do
    it "rooms_each_category" do
      expect(category.rooms_each_category).to eq [room]
    end
  end
end
