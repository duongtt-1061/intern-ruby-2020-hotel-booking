class RoomPicture < ApplicationRecord
  ROOM_PICTURE = %i(id room_id image _destroy).freeze
  mount_uploader :image, RoomPictureUploader
  belongs_to :room
end
