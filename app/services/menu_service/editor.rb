class MenuService::Editor
  def initialize(params)
    @id = params.fetch(:id)
    @title = params.fetch(:title)
  end

  def execute
    menu = Menu.find(@id)
    menu.update!(title: @title)
  end
end