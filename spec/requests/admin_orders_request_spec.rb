require "rails_helper"

RSpec.describe Admins::OrdersController, type: :controller do
  let(:category) {FactoryBot.create :category}
  let(:room) {FactoryBot.create :room, {category: category}}
  let(:user) {FactoryBot.create :user, role: "admin"}
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

  before {login user}

  describe "GET #index" do
    before {get :index}

    it "assign a @orders and render template index" do
      aggregate_failures do
        expect(response).to render_template :index
        expect(assigns(:orders)).to eq [order_two, order_three]
      end
    end
  end

  describe "PATCH #update" do
    context "when valid params" do
      before {patch :update, params: {id: order.id,
                                      order: {status: "approved"}}}

      it "should update order and redirect to admins_orders_path with flash" do
        aggregate_failures do
          expect(response).to redirect_to admins_orders_path
          expect(assigns(:order).status).to eq "approved"
          expect(flash[:success]).to eq I18n.t("admins.update_success")
        end
      end
    end

    context "when invalid params" do
      before {patch :update, params: {id: order.id,
                                      order: {quantity_person: "abc"}}}

      it "should not update order and render edit with error flash" do
        aggregate_failures do
          expect(response).to render_template :edit
          expect(assigns(:order).quantity_person).not_to eq "abc"
          expect(flash[:danger]).to eq I18n.t("admins.update_false")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when cannot find order" do
      before {delete :destroy, xhr: true, params: {id: "abc"}}

      it "should redirect to admins_root_path with danger flash" do
        expect(response).to redirect_to admins_root_path
        expect(flash[:danger]).to eq I18n.t("admins.order_not_found")
      end
    end

    context "when can find order" do
      before {delete :destroy, xhr: true, params: {id: order.id}}

      it "should destroy order" do
        expect(assigns(:order).destroyed?).to eq true
      end
    end
  end
end
