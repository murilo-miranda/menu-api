class MenuService::Destroyer
  def initialize(params)
    @id = params[:id]
  end

  def execute
    menu = Menu.find(@id)
    menu.destroy!
  end
end
