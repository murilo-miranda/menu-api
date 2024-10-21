class Menu < ApplicationRecord
  has_many :menu_items_menus
  has_many :restaurants_menus
  has_many :menu_items, through: :menu_items_menus, dependent: :destroy
  has_many :restaurants, through: :restaurants_menus
  accepts_nested_attributes_for :menu_items

  validates :title, presence: true
end
