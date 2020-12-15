class RemoveColumnTableRoom < ActiveRecord::Migration[6.0]
  def change
    remove_column :rooms, :image
  end
end
