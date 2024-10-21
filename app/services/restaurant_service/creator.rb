class RestaurantService::Creator
  def initialize(params)
    @name = params[:name]
  end

  def execute
    Restaurant.create!(name: @name)
  end
end
