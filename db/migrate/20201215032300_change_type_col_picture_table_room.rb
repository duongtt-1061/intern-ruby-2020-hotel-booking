class ChangeTypeColPictureTableRoom < ActiveRecord::Migration[6.0]
  def change
    change_column :rooms, :pictures, :text
  end
end
