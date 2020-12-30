require "rails_helper"

RSpec.describe RoomsController, type: :controller do
  let(:category) {FactoryBot.create :category}
  let!(:room) {FactoryBot.create :room, {category: category}}
  let!(:room_two) {FactoryBot.create :room, {category: category}}

  describe "GET #index" do
    context "when valid params" do
      before {get :index, params: {slug: category.slug}}

      it "assign a @rooms and render template index" do
        aggregate_failures do
          expect(response).to render_template :index
          expect(assigns(:rooms)).to eq [room, room_two]
        end
      end
    end

    context "when invalid params" do
      before {get :index, params: {slug: "abc"}}

      it "should redirect to root_path with a danger flash" do
        aggregate_failures do
          expect(response).to redirect_to root_path
          expect(flash[:danger]).to eq I18n.t("rooms.cate_not_found")
        end
      end
    end
  end

  describe "GET #show" do
    context "when valid params" do
      before {get :show, params: {slug: room.slug}}

      it "assign a @room and render template show" do
        aggregate_failures do
          expect(response).to render_template :show
          expect(assigns(:room)).to eq room
        end
      end
    end

    context "when invalid params" do
      before {get :show, params: {slug: "abc"}}

      it "assign a @room and render template show" do
        aggregate_failures do
          expect(response).to redirect_to root_path
          expect(flash[:danger]).to eq I18n.t("rooms.room_not_found")
        end
      end
    end
  end
end
