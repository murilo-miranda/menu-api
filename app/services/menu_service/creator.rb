class MenuService::Creator
  def initialize(params)
    @params = params
  end

  def execute
    Menu.create!(@params)
  end
end
