class MenuItemService::Editor
  def initialize(params)
    @params = params
  end

  def execute
    menu_item = MenuItem.find(@params[:id])
    menu_item.update!(@params)
    menu_item
  end
end
