class MenuService::Destroyer
  def initialize(params)
    @id = params.fetch(:id)
  end

  def execute
    menu = Menu.find(@id)
    menu.destroy!
  end
end
