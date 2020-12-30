require "rails_helper"

RSpec.describe SearchController, type: :controller do
  let(:category) {FactoryBot.create :category}
  let!(:room) {FactoryBot.create :room, {category: category}}
  let!(:room_two) {FactoryBot.create :room, {category: category}}

  describe "GET #index" do
    before {get :index}

    it "assign a @rooms and render template index" do
      aggregate_failures do
        expect(response).to render_template :index
        expect(assigns(:rooms)).to eq [room, room_two]
      end
    end
  end
end
