class MenuService::Creator
  def initialize(title)
    @title = title
  end

  def execute
    Menu.create!(@title)
  end
end
