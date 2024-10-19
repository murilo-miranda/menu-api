class MenuItemService::Creator
  def initialize(params)
    @name = params[:name]
    @description = params[:description]
    @price = params[:price]
    @menu_ids = params[:menu_ids]
  end

  def execute
    MenuItem.create!(
      name: @name,
      description: @description,
      price: @price,
      menu_ids: @menu_ids
    )
  end
end
