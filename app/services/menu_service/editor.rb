class MenuService::Editor
  def initialize(params)
    @id = params[:id]
    @title = params[:title]
  end

  def execute
    menu = Menu.find(@id)
    menu.update!(title: @title)
    menu
  end
end