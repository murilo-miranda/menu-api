class Restaurant < ApplicationRecord
  has_many :restaurants_menus, class_name: "RestaurantsMenu"
  has_many :menus, through: :restaurants_menus

  validates :name, presence: true
end
