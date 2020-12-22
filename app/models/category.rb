class Category < ApplicationRecord
  has_many :rooms, dependent: :destroy

  def rooms_each_category
    rooms.includes(:room_pictures)
         .top_hired
         .limit Settings.model.limit.rooms_per_cate
  end
end
