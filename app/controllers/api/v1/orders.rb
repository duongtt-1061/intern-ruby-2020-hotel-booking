module API
  module V1
    class Orders < Grape::API
      include API::V1::Defaults
      helpers API::V1::Helpers::AuthenticationHelpers

      before do
        authenticate_user!
      end

      helpers do
        def order_params
          ActionController::Parameters.new(params[:order])
                                      .permit Order::ORDER_PARAMS
        end
      end

      resource :orders do
        desc "Return all orders for user"
        get "" do
          @current_user.orders.includes([:room])
        end

        desc "Return a order"
        params do
          requires :id, type: Integer, desc: "ID of the order"
        end
        get "detail/:id" do
          @order = Order.find params[:id]
          authorize! :read, @order
          @order
        end

        desc "User create new order"
        post "create" do
          @current_user.orders.create! order_params
        end
      end
    end
  end
end
