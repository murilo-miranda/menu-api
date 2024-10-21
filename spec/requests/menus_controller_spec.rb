require 'rails_helper'

# frozen_string_literal: true

describe "Menus", type: :request do
  context "POST v1/menus" do
    context "with required attributes" do
      context "and with restaurant/menu item association" do
        let!(:menu_item) {
          MenuItem.create(
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69
          )
        }
        let!(:restaurant) { Restaurant.create(name: 'Mc Donalds') }
        let(:expected_response) {
          {
            id: Menu.last.id,
            title: Menu.last.title,
            menu_items: [
              {
                id: menu_item.id,
                name: menu_item.name,
                description: menu_item.description,
                price: menu_item.price
              }
            ],
            restaurants: [
              {
                id: restaurant.id,
                name: restaurant.name
              }
            ]
          }
        }

        it "should return created menu with menu item association and status 201" do
          post '/v1/menus', params: {
            title: "Burguers",
            menu_item_ids: [ menu_item.id ],
            restaurant_ids: [ restaurant.id ]
          }

          expect(response.status).to eq(201)
          expect(response.body).to eq(expected_response.to_json)
        end
      end

      context "and without restaurant/menu item association" do
        let!(:menu_item) {
          MenuItem.create(
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69
          )
        }
        let(:expected_response) {
          {
            id: Menu.last.id,
            title: Menu.last.title,
            menu_items: [],
            restaurants: []
          }
        }

        it "should return created menu with menu item association and status 201" do
          post '/v1/menus', params: { title: "Burguers" }

          expect(response.status).to eq(201)
          expect(response.body).to eq(expected_response.to_json)
        end
      end
    end

    context "without required attributes" do
      it "should return error message with status 422 " do
        post '/v1/menus'

        expect(response.status).to eq(422)
        expect(response.body).to eq("Validation failed: Title can't be blank")
      end
    end
  end

  context "DELETE /v1/menus/:id" do
    context "with existed id" do
      let!(:menu) { Menu.create(title: 'Burguers') }

      it "should return empty body with status 204" do
        delete "/v1/menus/#{menu.id}"

        expect(response.status).to eq(204)
        expect(response.body).to eq("")
      end
    end

    context "with non existed id" do
      let!(:menu) { Menu.create(title: 'Burguers') }

      it "should return empty body with status 204" do
        delete "/v1/menus/999999"

        expect(response.status).to eq(404)
        expect(response.body).to eq("Couldn't find Menu with 'id'=999999")
      end
    end
  end

  context "PUT /v1/menus/:id" do
    context "with existed id" do
      context "with required attribute" do
        let!(:menu) { Menu.create(title: 'Burguers') }
        let(:expected_response) {
          {
            id: menu.id,
            title: menu.reload.title
          }
        }

        it "should return the record with new value with status 200" do
          put "/v1/menus/#{menu.id}", params: {
            title: "Pasta"
          }

          expect(response.status).to eq(200)
          expect(response.body).to be_json.with_content(expected_response)
        end
      end

      context "without required attribute" do
        let!(:menu) { Menu.create(title: 'Burguers') }

        it "should return the record with new value with status 422" do
          put "/v1/menus/#{menu.id}"

          expect(response.status).to eq(422)
          expect(response.body).to eq("Validation failed: Title can't be blank")
        end
      end
    end

    context "without existed id" do
      let!(:menu) { Menu.create(title: 'Burguers') }

      it "should return error message with status 404" do
        put "/v1/menus/999999", params: {
          title: "Pasta"
        }

        expect(response.status).to eq(404)
        expect(response.body).to eq("Couldn't find Menu with 'id'=999999")
      end
    end
  end

  context "GET /v1/menus/:id" do
    let!(:menu) { Menu.create(title: 'Burguers') }

    context "with existed id" do
      context "without restaurant/menu item" do
        let(:expected_response) {
          {
            id: menu.id,
            title: menu.title,
            menu_items: [],
            restaurants: []
          }
        }

        it "should return the menu record with association and status 200" do
          get "/v1/menus/#{menu.id}"

          expect(response.status).to eq(200)
          expect(response.body).to be_json.with_content(expected_response)
        end
      end

      context "with restaurant/menu item" do
        let!(:menu_item) {
          MenuItem.create(
            name: 'The Classic',
            description: 'Buns, patties, chopped onions, ketchup, mustard',
            price: 2.19,
            menu_ids: [ menu.id ]
          )
        }
        let!(:restaurant) { Restaurant.create(name: 'Mc Donalds', menu_ids: [ menu.id ]) }
        let(:expected_response) {
          {
            id: menu.id,
            title: menu.title,
            menu_items: [
              {
                id: menu_item.id,
                name: menu_item.name,
                description: menu_item.description,
                price: menu_item.price
              }
            ],
            restaurants: [
              id: restaurant.id,
              name: restaurant.name
            ]
          }
        }

        it "should return the menu record with association and status 200" do
          get "/v1/menus/#{menu.id}"

          expect(response.status).to eq(200)
          expect(response.body).to eq(expected_response.to_json)
        end
      end
    end

    context "without existed id" do
      it "should return error message with status 404" do
        get "/v1/menus/999999"

        expect(response.status).to eq(404)
        expect(response.body).to eq("Couldn't find Menu with 'id'=999999")
      end
    end
  end

  context "GET /v1/menus" do
    let!(:menu) { Menu.create(title: "Burguers") }
    let!(:menu2) { Menu.create(title: "Lunch") }

    context "without restaurant/menu item" do
      let(:expected_response) {
        [
          {
            id: menu.id,
            title: menu.title,
            menu_items: [],
            restaurants: []
          },
          {
            id: menu2.id,
            title: menu2.title,
            menu_items: [],
            restaurants: []
          }
        ]
      }

      it "should return menu collection with status 200" do
        get "/v1/menus"

        expect(response.status).to eq(200)
        expect(response.body).to eq (expected_response.to_json)
      end
    end

    context "with restaurant/menu item" do
      let!(:menu_item) {
        MenuItem.create(
          name: 'The Classic',
          description: 'Buns, patties, chopped onions, ketchup, mustard',
          price: 2.19,
          menu_ids: [ menu.id ]
        )
      }
      let!(:restaurant) { Restaurant.create(name: 'Mc Donalds', menu_ids: [ menu.id ]) }

      let(:expected_response) {
        [
          {
            id: menu.id,
            title: menu.title,
            menu_items: [
              {
                id: menu_item.id,
                name: menu_item.name,
                description: menu_item.description,
                price: menu_item.price
              }
            ],
            restaurants: [
              {
                id: restaurant.id,
                name: restaurant.name
              }
            ]
          },
          {
            id: menu2.id,
            title: menu2.title,
            menu_items: [],
            restaurants: []
          }
        ]
      }

      it "should return menu collection with menu items and status 200" do
        get "/v1/menus"

        expect(response.status).to eq(200)
        expect(response.body).to eq (expected_response.to_json)
      end
    end
  end
end
