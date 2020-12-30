require "rails_helper"

RSpec.describe Supply, type: :model do
  describe "associations" do
    it { should have_many(:room_supplies) }
  end
end
