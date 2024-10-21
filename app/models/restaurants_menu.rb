class RestaurantsMenu < ApplicationRecord
  belongs_to :restaurant
  belongs_to :menu
end