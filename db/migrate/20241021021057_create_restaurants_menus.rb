class CreateRestaurantsMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants_menus do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
