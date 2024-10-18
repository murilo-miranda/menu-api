class MenuItemService::Destroyer
  def initialize(params)
    @id = params[:id]
  end

  def execute
    menu_item = MenuItem.find(@id)
    menu_item.destroy!
  end
end
