class MenuItem < ApplicationRecord
  has_many :menu_items_menus
  has_many :menus, through: :menu_items_menus
  accepts_nested_attributes_for :menus

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
end
