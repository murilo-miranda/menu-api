class V1::MenusController < ApplicationController
  def create
    begin
      menu = Menu.create!(menu_params)
      render json: json_response(menu), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
    end
  end

  private

    def menu_params
      params.permit(:title)
    end

    def json_response(menu)
      menu.attributes.except('created_at', 'updated_at').to_json
    end
end