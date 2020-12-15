class AddPicturesToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :pictures, :json
  end
end
