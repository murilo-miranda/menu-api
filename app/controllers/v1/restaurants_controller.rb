class V1::RestaurantsController < ApplicationController
  def index
    restaurants = Restaurant.all
    render json: json_association_response(restaurants), status: :ok
  end

  def create
    begin
      restaurant = RestaurantService::Creator.new(restaurant_params).execute
      render json: json_association_response(restaurant), status: :created
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

  def show
    begin
      restaurant = Restaurant.find(params[:id])
      render json: json_association_response(restaurant), status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    end
  end

  def update
    begin
      restaurant = RestaurantService::Editor.new(restaurant_params).execute
      render json: json_association_response(restaurant), status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
    end
  end

  private

    def restaurant_params
      params.permit(:id, :name, menu_ids: [])
    end

    def json_association_response(restaurant)
      restaurant.as_json(
        except: [ :created_at, :updated_at ],
        include: { menus: { except: [ :created_at, :updated_at ] } }
      )
    end
end
