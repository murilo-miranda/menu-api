class MenuService::Creator
  def initialize(params)
    @title = params[:title]
  end

  def execute
    Menu.create!(title: @title)
  end
end
