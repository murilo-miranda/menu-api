class RestaurantService::Creator
  def initialize(params)
    @params = params
  end

  def execute
    Restaurant.create!(@params)
  end
end
