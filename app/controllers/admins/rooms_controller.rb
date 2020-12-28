class Admins::RoomsController < Admins::BaseController
  before_action :find_room, only: %i(edit update destroy)
  before_action :get_room, only: :index

  def index
    @q = Room.ransack params[:q]
    @rooms = @q.result
               .by_id_desc
               .includes(:category, :room_pictures, :supplies)
               .page(params[:page])
               .per Settings.rooms.num_record
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new room_params
    if @room.save
      flash[:success] = t "admins.add_success"
      redirect_to admins_rooms_path
    else
      flash.now[:danger] = t "admins.add_false"
      render :new
    end
  end

  def edit; end

  def update
    if @room.update room_params
      flash[:success] = t "admins.update_success"
      redirect_to admins_rooms_path
    else
      flash.now[:danger] = t "admins.update_false"
      render :edit
    end
  end

  def destroy
    @room.destroy
    respond_to :js
  end

  private

  def room_params
    params.require(:room).permit Room::ROOM_PERMIT
  end

  def find_room
    @room = Room.find_by id: params[:id]
    return if @room

    flash[:danger] = t "admins.room_not_found"
    redirect_to admins_root_path
  end

  def get_room
    @rooms = Room.search_by_name(params[:name])
                 .relate_room(params[:cate_id])
                 .search_start_price(params[:start_price])
                 .search_end_price params[:end_price]
  end
end
