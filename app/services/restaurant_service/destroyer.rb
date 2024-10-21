class RestaurantService::Destroyer
  def initialize(params)
    @id = params[:id]
  end

  def execute
    restaurant = Restaurant.find(@id)
    restaurant.destroy!
  end
end
