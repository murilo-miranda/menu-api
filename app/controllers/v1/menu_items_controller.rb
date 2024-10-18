class V1::MenuItemsController < ApplicationController
  def create
    begin
      menu = MenuItemService::Creator.new(menu_items_params).execute
      render json: json_response(menu), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
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
