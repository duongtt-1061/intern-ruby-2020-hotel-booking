require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  let(:category) {FactoryBot.create :category}
  let(:room) {FactoryBot.create :room, {category: category}}
  let(:user) {FactoryBot.create :user}
  let(:user_two) {FactoryBot.create :user}
  let(:order) {FactoryBot.create :order, user: user,
                                         room: room}
  let!(:order_two) do
    FactoryBot.create :order, user: user,
                              room: room,
                              date_start: "2020-12-21",
                              date_end: "2020-12-25"
  end

  let!(:order_three) do
    FactoryBot.create :order, user: user,
                              room: room,
                              date_start: "2020-12-26",
                              date_end: "2020-12-30",
                              status: :approved,
                              created_at: "2020-10-10"
  end

  let(:order_four) do
    FactoryBot.create :order, user: user,
                              room: room,
                              date_start: "2020-12-26",
                              date_end: "2020-12-30",
                              status: :cancel
  end

  let(:params_order) {FactoryBot.attributes_for :order}
  let(:invalid_params_order) {FactoryBot.attributes_for :order, date_start: nil}

  before {login user}

  describe "check_login" do
    before {get :index, params: {page: 1, user_id: user.id},
                        session:{user_id: nil}}
    it "should redirect to root_path" do
      expect(response).to redirect_to login_path
    end
  end

  describe "GET #index" do
    before {get :index, params: {page: 1,
                                 user_id: user.id}}

    it "should render the 'index' template with @orders" do
      aggregate_failures do
        expect(response).to render_template :index
        expect(assigns(:orders)).to eq [order_three, order_two]
      end
    end
  end

  describe "GET #show" do
    context "when valid param" do
      before {get :show, params: {user_id: user.id, id: order.id}}

      it "should render the 'show' template with @order" do
        aggregate_failures do
          expect(response).to render_template :show
          expect(assigns(:order)).to eq order
        end
      end
    end

    context "when not correct user" do
      before {get :show, params: {user_id: user_two.id, id: order.id}}

      it "should redirect to index of current user" do
        expect(response).to redirect_to user_orders_path user
      end
    end

    context "when invalid param id" do
      before {get :show, params: {user_id: user.id, id: "abc"}}

      it "should return a invalid order" do
        expect(assigns(:order)).to eq nil
      end

      it "should redirect to index of current user" do
        expect(response).to redirect_to user_orders_path user
      end
    end
  end

  describe "GET #new" do
    context "when valid param" do
      before {get :new, params: {user_id: user.id,
                               room_id: room.id,
                               date_start: "2020-12-21",
                               date_end: "2020-12-22"}}

      it "should render the 'new' template" do
        expect(response).to render_template :new
      end
    end

    context "when invalid param room_id" do
      before {get :new, params: {user_id: user.id,
                                 date_start: "2020-12-21",
                                 date_end: "2020-12-22"}}

      it "should redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when empty param date_start" do
      before {get :new, params: {user_id: user.id,
                                 room_id: room.id,
                                 date_end: "2020-12-22"}}

      it "should have date_start equal today" do
        expect(assigns(:date_start)).to eq Time.zone.today.to_s
      end
    end
  end

  describe "POST #create" do
    context "when valid param" do
      before {post :create, params: {user_id: user.id,
                                     room_id: room.id,
                                     date_start: "2020-12-21",
                                     date_end: "2020-12-22",
                                     order: {quantity_person: 1,
                                             date_start: "2020-12-21",
                                             date_end: "2020-12-22"}}}

      it "should create new order" do
        expect{
          post :create, params: {user_id: user.id,
                                 room_id: room.id,
                                 order: params_order.merge(order: {quantity_person: 1,
                                                                   date_start: "2020-12-21",
                                                                   date_end: "2020-12-22"})}
        }.to change(Order, :count).by 1
      end

      it "should redirect to rooth path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when invalid param" do
      before {post :create, params: {user_id: user.id,
                                     room_id: room.id,
                                     date_start: "2020-12-21",
                                     date_end: "2020-12-22",
                                     order: {quantity_person: 1,
                                             date_start: "2020-12-21",
                                             date_end: "2020-12-22"}}}

      it "should not create new order" do
        expect{
          post :create, params: {user_id: user.id,
                                 room_id: room.id,
                                 order: invalid_params_order.merge(order: {quantity_person: 1,
                                                                           date_start: "2020-12-21",
                                                                           date_end: "2020-12-22"})}
        }.to change(Order, :count).by 0
      end

      it "should redirect to rooth path" do
        expect(response).to redirect_to root_path
      end

      context "when quantity people more than allow" do
        before(:each) do
          request.env["HTTP_REFERER"] = root_path

          post :create, params: {user_id: user.id,
                                     room_id: room.id,
                                     date_start: "2020-12-21",
                                     date_end: "2020-12-22",
                                     order: {quantity_person: 1000,
                                             date_start: "2020-12-21",
                                             date_end: "2020-12-22"}}
        end

        it "should have a danger flash" do
          expect(flash[:danger]).to eq I18n.t("orders.create.warning_for_quantity_person")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when valid params" do
      context "when status can destroy" do
        before {delete :destroy, xhr: true, params: {id: order.id, user_id: user.id}}

        it "should update status order to cancel" do
          expect(assigns(:order).status).to eq "cancel"
        end
      end

      context "when status can not destroy" do
        context "when status equal approved and created_at more than 24 hours" do
          before {delete :destroy, xhr: true, params: {id: order_three.id, user_id: user.id}}

          it "should not update status order to cancel" do
            expect(assigns(:order).status).not_to eq "cancel"
          end
        end

        context "when status not equal pendding and approved" do
          before {delete :destroy, xhr: true, params: {id: order_four.id, user_id: user.id}}

          it "should not can update status order" do
            expect(assigns(:order).status).to eq order_four.status
          end
        end
      end
    end

    context "when invalid params" do
      before {delete :destroy, xhr: true, params: {id: "xzy", user_id: user.id}}

      it "should not update status order" do
        expect(assigns(:order)).to eq nil
      end
    end
  end

  describe "GET #edit" do
    context "when valid params" do
      before {get :edit, params: {user_id: user.id, id: order.id}}

      it "should assign @order" do
        expect(assigns(:order)).to eq order
      end

      it "should render template 'edit'" do
        expect(response).to render_template :edit
      end
    end

    context "when invalid params" do
      before {get :edit, params: {user_id: user.id, id: "ghz"}}

      it "should assign @order equal nil" do
        expect(assigns(:order)).to eq nil
      end

      it "should redirect to user_orders_path" do
        expect(response).to redirect_to user_orders_path user
      end
    end
  end

  describe "PATCH #update" do
    context "when valid params" do
      before {patch :update, params: {user_id: user.id,
                                      id: order.id,
                                      room_id: room.id,
                                      order: {quantity_person: 1,
                                              date_start: "2020-12-29",
                                              date_end: "2020-12-30"}}}

      it "should update order" do
        aggregate_failures do
          expect(flash[:success]).to eq I18n.t("update_order_successful")
          expect(response.status).to eq(302)
          expect(response.body).to include("redirected")
        end
      end
    end

    context "when invalid params" do
      before {patch :update, params: {user_id: user.id,
                                      id: order.id,
                                      room_id: room.id,
                                      order: {quantity_person: "abc",
                                              date_start: "2020-12-29",
                                              date_end: nil}}}

      it "should have flash danger" do
        aggregate_failures do
          expect(flash[:danger]).to eq I18n.t("update_order_failed")
          expect(response.status).to eq(200)
          expect(response).to render_template :edit
        end
      end
    end
  end
end
