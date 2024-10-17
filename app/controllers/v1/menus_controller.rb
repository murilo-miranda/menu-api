class V1::MenusController < ApplicationController
  def create
    begin
      menu = Menu.create!(menu_params)
      render json: menu.to_json, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
    end
  end

  private

    def menu_params
      params.permit(:title)
    end
end