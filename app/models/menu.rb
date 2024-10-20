class Menu < ApplicationRecord
  has_many :menu_items_menus
  has_many :menu_items, through: :menu_items_menus, dependent: :destroy

  validates :title, presence: true
end
