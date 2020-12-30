class Admins::OrdersController < Admins::BaseController
  before_action :find_order, only: %i(edit update destroy)

  def index
    @q = Order.ransack params[:q], auth_object: set_ransack_auth_object

    @orders = @q.result
                .includes(:room, :user)
                .page(params[:page])
                .per Settings.rooms.num_record
  end

  def edit; end

  def update
    if @order.update order_change_status_params
      flash[:success] = t "admins.update_success"
      redirect_to admins_orders_path
    else
      flash.now[:danger] = t "admins.update_false"
      render :edit
    end
  end

  def destroy
    @order.destroy
    respond_to :js
  end

  private

  def order_change_status_params
    params.require(:order).permit Order::ORDER_CHANGE_STATUS_PERMIT
  end

  def find_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "admins.order_not_found"
    redirect_to admins_root_path
  end
end
