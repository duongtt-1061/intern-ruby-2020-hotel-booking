class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_current_user
  before_action :find_room, only: %i(new create update)
  before_action :valid_date_for_booking,
                :get_booked_room_for_booking,
                only: :new

  before_action :check_max_person,
                only: :create

  before_action :find_order, except: %i(index new create)

  layout false, only: :new

  def index
    @orders = current_user.orders.includes(:room)
                          .order_id_desc
                          .order_status_asc
                          .page(params[:page])
                          .per Settings.per.order
  end

  def show; end

  def new
    return request.referer unless @booked_room.empty?

    hash_params = {room: @room,
                   quantity_person: params[:quantity_person],
                   date_start: @date_start,
                   date_end: @date_end,
                   price:
                   (@date_end.to_date - @date_start.to_date + 1) * @room.price}
    @order = current_user.orders.new hash_params
  end

  def create
    order = current_user.orders.build order_params
    if order.save
      flash[:success] = t "flash_create_new_order_success"
    else
      flash.now[:danger] = t "something_wrong"
    end
    redirect_to root_path
  end

  def destroy
    if can_destroy?
      @order.update status: "cancel"
      @message = t "orders.destroy.delete_success"
    end
    respond_to :js
  end

  def edit; end

  def update
    if @order.update order_params
      flash[:success] = t "update_order_successful"
      redirect_to user_orders_path
    else
      flash[:danger] = t "update_order_failed"
      render :edit
    end
  end

  private

  def order_params
    params[:order].merge! room_id: params[:room_id],
                          price: @room.price * (get_total_date + 1),
                          status: Settings.status.pendding,
                          booking_attributes: booking_params
    params.require(:order).permit Order::ORDER_PARAMS
  end

  def find_room
    @room = Room.find_by id: params[:room_id]
    return if @room.present?

    flash[:danger] = t "something_wrong"
    redirect_to root_path
  end

  def booking_params
    {room_id: params[:room_id],
     date_start: params[:order][:date_start],
     date_end: params[:order][:date_end],
     quantity_person: params[:order][:quantity_person]}
  end

  def check_max_person
    return if params[:order][:quantity_person].to_i <= @room.max_person

    flash[:danger] = t ".warning_for_quantity_person"
    redirect_to request.referer
  end

  def get_total_date
    return 0 if params[:order][:date_start].blank? ||
                params[:order][:date_end].blank?

    (params[:order][:date_end].to_date - params[:order][:date_start].to_date)
  end

  def check_current_user
    user = User.find_by id: params[:user_id]
    return if current_user? user

    flash[:danger] = t "something_wrong"
    redirect_to user_orders_path current_user
  end

  def find_order
    @order = Order.find_by id: params[:id]

    return if @order

    flash[:danger] = t "something_wrong"
    redirect_to user_orders_path current_user
  end

  def can_destroy?
    if @order.pendding?
      true
    elsif @order.approved?
      not_expired = @order.not_expire_to_destroy?
      @message = t "message_cannot_destroy_order" unless not_expired
      not_expired
    else
      false
    end
  end
end
