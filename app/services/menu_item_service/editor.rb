class MenuItemService::Editor
  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @description = params[:description]
    @price = params[:price]
  end

  def execute
    menu_item = MenuItem.find(@id)
    menu_item.update!(
      name: @name,
      description: @description,
      price: @price,
    )
    menu_item
  end
end
