class V1::MenuItemsController < ApplicationController
  def show
    begin
      menu_item = MenuItem.find(params[:id])
      render json: json_response(menu_item), status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    end
  end

  def create
    begin
      menu_item = MenuItemService::Creator.new(menu_items_params).execute
      render json: json_response(menu_item), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
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

  private

    def menu_items_params
      params.permit(:id, :name, :description, :price, :menu_id)
    end

    def json_response(menu)
      menu.attributes.except("created_at", "updated_at").to_json
    end
end
