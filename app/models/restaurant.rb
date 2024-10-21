class Restaurant < ApplicationRecord
  has_many :restaurants_menus, dependent: :destroy, class_name: "RestaurantsMenu"
  has_many :menus, through: :restaurants_menus
  accepts_nested_attributes_for :menus

  validates :name, presence: true
end
