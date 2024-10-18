class MenuItemService::Creator
  def initialize(params)
    @menu_id = params[:menu_id]
    @name = params[:name]
    @description = params[:description]
    @price = params[:price]
  end

  def execute
    MenuItem.create!(
      name: @name,
      description: @description,
      price: @price,
      menu_id: @menu_id
    )
  end
end
