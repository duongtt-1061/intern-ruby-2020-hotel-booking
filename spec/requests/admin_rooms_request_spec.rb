require "rails_helper"

RSpec.describe Admins::RoomsController, type: :controller do
  let(:user) {FactoryBot.create :user, role: "admin"}
  let(:category) {FactoryBot.create :category}
  let!(:room) {FactoryBot.create :room, {category: category}}
  let!(:room_two) {FactoryBot.create :room, {category: category}}

  before {login user}

  describe "GET #index" do
    before {get :index}

    it "assign a @rooms and render template index" do
      aggregate_failures do
        expect(response).to render_template :index
        expect(assigns(:rooms)).to eq [room_two, room]
      end
    end
  end

  describe "GET #new" do
    before {get :new}

    it "assign a @room and render template new" do
      aggregate_failures do
        expect(response).to render_template :new
        expect(assigns(:room))
      end
    end
  end

  describe "POST #create" do
    context "when valid params" do
      before {post :create, params: {room: {name: "roomnew123",
                                            slug: "roomnew123",
                                            category_id: category.id,
                                            price: 50,
                                            description: "aaaaaaaaaaaaaaaaaa",
                                            map: "aaaaaaaaaaaaaaaaaa",
                                            address: "aaaaaaaaaaaaaaaaaa",
                                            max_person: 2}}}

      it "should create new room and redirect to admins_rooms_path" do
        aggregate_failures do
          expect(response).to redirect_to admins_rooms_path
          expect{post :create, params: {room: {name: "roomnew123",
                                               slug: "roomnew123",
                                               category_id: category.id,
                                               price: 50,
                                               description: "aaaaaaaaaaaaaaaaaa",
                                               map: "aaaaaaaaaaaaaaaaaa",
                                               address: "aaaaaaaaaaaaaaaaaa",
                                               max_person: 2}}
          }.to change(Room, :count).by 1
        end
      end
    end

    context "when invalid params" do
      before {post :create, params: {room: {category_id: category.id,
                                            price: 50,
                                            max_person: 2}}}

      it "should not create new room and render new with danger flash" do
        aggregate_failures do
          expect(response).to render_template :new
          expect(flash[:danger]).to eq I18n.t(".admins.add_false")
          expect{post :create, params: {room: {category_id: category.id,
                                               price: 50,
                                               max_person: 2}}
          }.to change(Room, :count).by 0
        end
      end
    end
  end

  describe "PATCH #update" do
    context "when valid params" do
      before {patch :update, params: {id: room.id, room: {max_person: 3}}}

      it "should update room and redirect to admins_rooms_path with flash" do
        aggregate_failures do
          expect(response).to redirect_to admins_rooms_path
          expect(assigns(:room).max_person).to eq 3
          expect(flash[:success]).to eq I18n.t("admins.update_success")
        end
      end
    end

    context "when invalid params" do
      before {patch :update, params: {id: room.id, room: {name: nil}}}

      it "should not update room and render template edit with danger flash" do
        aggregate_failures do
          expect(response).to render_template :edit
          expect(assigns(:room).name).not_to eq nil
          expect(flash[:danger]).to eq I18n.t("admins.update_false")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when valid params" do
      before {delete :destroy, xhr: true, params: {id: room.id}}

      it "should destroy room" do
        expect(assigns(:room).destroyed?).to eq true
      end
    end

    context "when invalid params" do
      before {delete :destroy, xhr: true, params: {id: "abc"}}

      it "should not find room to destroy and redirect to admins_root_path" do
        expect(response).to redirect_to admins_root_path
      end
    end
  end

  describe "check role admin in BaseController" do
    context "when user not has role admin" do
      let(:user_two) {FactoryBot.create :user}

      before do
        sign_in user_two
        get :index
      end

      it "should redirect to root_path with danger flash" do
        aggregate_failures do
          expect(flash[:danger]).to eq I18n.t("admins.not_admin")
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
