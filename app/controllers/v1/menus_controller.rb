class V1::MenusController < ApplicationController
  def index
    menus = Menu.all
    render json: json_association_response(menus), status: :ok
  end

  def show
    begin
      menu = Menu.find(params[:id])
      render json: json_association_response(menu), status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    end
  end

  def create
    begin
      menu = MenuService::Creator.new(menu_params).execute
      render json: json_association_response(menu), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    end
  end

  def destroy
    begin
      MenuService::Destroyer.new(menu_params).execute
      render json: {}, status: :no_content
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    end
  end

  def update
    begin
      menu = MenuService::Editor.new(menu_params).execute
      render json: json_response(menu), status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: e.message, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
    end
  end

  private

    def menu_params
      params.permit(:id, :title, menu_item_ids: [], restaurant_ids: [])
    end

    def json_response(menu)
      menu.attributes.except("created_at", "updated_at").to_json
    end

    def json_association_response(menu)
      menu.as_json(
        except: [ :created_at, :updated_at ],
        include: {
          menu_items: { except: [ :created_at, :updated_at ] },
          restaurants: { except: [ :created_at, :updated_at ] }
        }
      )
    end
end
