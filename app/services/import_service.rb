class ImportService
  def initialize(json_data)
    @json_data = json_data
  end

  def execute
    restaurants = @json_data["restaurants"]

    restaurants.each do |restaurant_data|
      begin
        restaurant = Restaurant.create(name: restaurant_data["name"])
        logger.info "Imported restaurant: #{restaurant.name}"
      rescue StandardError => e
        logger.error "Failed to import restaurant: #{restaurant_data['name']} (#{e.message})"
        raise e
      end

      menus = restaurant_data["menus"]

      menus.each do |menu_data|
        begin
          menu = Menu.create(title: menu_data["name"], restaurant_ids: [ restaurant.id ])
          logger.info "Imported menu: #{menu.title}"
        rescue StandardError => e
          logger.error "Failed to import menu: #{menu_data['name']} (#{e.message})"
          raise e
        end

        items = menu_data["menu_items"] || menu_data["dishes"]

        items.each do |item_data|
          begin
            item = MenuItem.create(name: item_data["name"], price: item_data["price"], menu_ids: [ menu.id ])
            logger.info "Imported menu item: #{item.name} (#{item.price})"
          rescue StandardError => e
            logger.error "Failed to import menu item: #{item_data['name']} (#{e.message})"
            raise e
          end
        end
      end
    end
  end

  private

  def logger
    Rails.logger
  end
end
