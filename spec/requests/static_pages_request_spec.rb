require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:category) {FactoryBot.create :category}
  let!(:room) {FactoryBot.create :room, {category: category}}
  let!(:room_two) {FactoryBot.create :room, {category: category}}

  describe "GET #home" do
    before {get :home}

    it "assign a @rooms" do
      aggregate_failures do
        expect(response).to render_template :home
        expect(assigns(:rooms)).to eq [room, room_two]
      end
    end
  end
end
