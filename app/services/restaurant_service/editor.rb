class RestaurantService::Editor
  def initialize(params)
    @id = params[:id]
    @name = params[:name]
  end

  def execute
    restaurant = Restaurant.find(@id)
    restaurant.update!(name: @name)
    restaurant
  end
end
