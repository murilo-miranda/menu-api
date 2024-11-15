class V1::MenuItemsController < ApplicationController
  def index
    menu_items = MenuItem.all
    render json: json_association_response(menu_items), status: :ok
  end

  def show
    begin
      menu_item = MenuItem.find(params[:id])
      render json: json_association_response(menu_item), status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    end
  end

  def create
    begin
      menu_item = MenuItemService::Creator.new(menu_items_params).execute
      render json: json_association_response(menu_item), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    end
  end

  def destroy
    begin
      MenuItemService::Destroyer.new(menu_items_params).execute
      render json: {}, status: :no_content
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    end
  end

  def update
    begin
      menu_item = MenuItemService::Editor.new(menu_items_params).execute
      render json: json_association_response(menu_item), status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
    end
  end

  private

    def menu_items_params
      params.permit(:id, :name, :description, :price, menu_ids: [])
    end

    def json_association_response(menu_item)
      menu_item.as_json(
        except: [ :created_at, :updated_at ],
        include: { menus: { except: [ :created_at, :updated_at ] } }
      )
    end
end
