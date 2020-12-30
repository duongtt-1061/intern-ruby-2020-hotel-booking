class SearchController < ApplicationController
  def index
    @rooms = Room.includes(:category)
                 .includes([:room_pictures])
                 .search_by_name(params[:name])
                 .relate_room(params[:cate_id])
                 .search_start_price(params[:start_price])
                 .search_end_price(params[:end_price])
                 .page(params[:page]).per Settings.rooms.num_record
  end
end
