class V1::RestaurantsController < ApplicationController
  def create
    begin
      restaurant = RestaurantService::Creator.new(restaurant_params).execute
      render json: json_response(restaurant), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      RestaurantService::Destroyer.new(restaurant_params).execute
      render json: {}, status: :no_content
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    end
  end

  private

    def restaurant_params
      params.permit(:id, :name)
    end

    def json_response(restaurant)
      restaurant.as_json(except: [ :created_at, :updated_at ])
    end
end
