class MenuItem < ApplicationRecord
  has_many :menu_items_menus
  has_many :menus, through: :menu_items_menus

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
end
