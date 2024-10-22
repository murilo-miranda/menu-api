class RemoveUniquenessFromMenuItems < ActiveRecord::Migration[7.2]
  def change
    remove_index :menu_items, :name
  end
end
