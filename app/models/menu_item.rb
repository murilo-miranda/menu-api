class MenuItem < ApplicationRecord
  has_many :menu_items_menus, dependent: :destroy
  has_many :menus, through: :menu_items_menus
  accepts_nested_attributes_for :menus

  validates :name, presence: true
  validates :price, presence: true
end
