class RestaurantService::Editor
  def initialize(params)
    @params = params
  end

  def execute
    restaurant = Restaurant.find(@params[:id])
    restaurant.update!(@params)
    restaurant
  end
end
