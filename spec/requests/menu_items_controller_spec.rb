require 'rails_helper'

# frozen_string_literal: true

describe "MenuItems", type: :request do
  context "POST v1/menu_items" do
    let!(:menu) { Menu.create(title: 'Burguers') }

    context "with params" do
      let(:expected_response) {
        {
          id: MenuItem.last.id,
          name: MenuItem.last.name,
          description: MenuItem.last.description,
          price: MenuItem.last.price,
          menus: [
            {
              id: menu.id,
              title: menu.title
            }
          ]
        }
      }

      it "should return created menu item with status 201" do
        post '/v1/menu_items', params: {
          name: 'Big Mac',
          description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
          price: 5.69,
          menu_ids: [ menu.id ]
        }

        expect(response.status).to eq(201)
        expect(response.body).to eq(expected_response.to_json)
      end

      context "with name already used" do
        let!(:menu_item) {
          MenuItem.create(
            name: 'The Classic',
            description: 'Buns, patties, chopped onions, ketchup, mustard',
            price: 2.19,
            menu_ids: [ menu.id ]
          )
        }

        let!(:new_menu_item) {
          MenuItem.create(
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69,
            menu_ids: [ menu.id ]
          )
        }

        let(:params) {
          {
            name: 'The Classic',
            description: 'Buns, patties, chopped onions, ketchup, mustard',
            price: 2.19,
            menu_ids: [ menu.id ]
          }
        }

        it "should return error message with status 422" do
          post "/v1/menu_items", params: params

          expect(response.status).to eq(422)
          expect(response.body).to eq("Validation failed: Name has already been taken")
        end
      end
    end

    context "without params" do
      it "should return error message with status 422 " do
        post '/v1/menu_items', params: {}

        expect(response.status).to eq(422)
        expect(response.body).to eq("Validation failed: Name can't be blank, Price can't be blank")
      end
    end
  end

  context "DELETE /v1/menu_items/:id" do
    let!(:menu) { Menu.create(title: 'Burguers') }
    let!(:menu_item) {
      MenuItem.create(
        name: 'Big Mac',
        description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
        price: 5.69,
        menu_ids: [ menu.id ]
      )
    }

    context "with existed id" do
      it "should return empty body with status 204" do
        delete "/v1/menu_items/#{menu_item.id}"

        expect(response.status).to eq(204)
        expect(response.body).to eq("")
      end
    end

    context "with non existed id" do
      it "should return empty body with status 404" do
        delete "/v1/menu_items/999999"

        expect(response.status).to eq(404)
        expect(response.body).to eq("Couldn't find MenuItem with 'id'=999999")
      end
    end
  end

  context "GET /v1/menu_items/:id" do
    let!(:menu) { Menu.create(title: 'Burguers') }
    let!(:menu_item) {
      MenuItem.create(
        name: 'Big Mac',
        description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
        price: 5.69,
        menu_ids: [ menu.id ]
      )
    }

    context "with existed id" do
      let(:expected_response) {
        {
          id: menu_item.id,
          name: menu_item.name,
          description: menu_item.description,
          price: menu_item.price,
          menus: [ {
            id: menu.id,
            title: menu.title
          } ]
        }
      }

      it "should return the menu item record with status 200" do
        get "/v1/menu_items/#{menu_item.id}"

        expect(response.status).to eq(200)
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context "with non existed id" do
      it "should return error message with status 404" do
        get "/v1/menu_items/999999"

        expect(response.status).to eq(404)
        expect(response.body).to eq("Couldn't find MenuItem with 'id'=999999")
      end
    end
  end

  context "PUT /v1/menu_items/:id" do
    context "with existed id" do
      let!(:menu) { Menu.create(title: 'Burguers') }
      let!(:menu_item) {
        MenuItem.create(
          name: 'Big Mac',
          description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
          price: 5.69,
          menu_ids: [ menu.id ]
        )
      }

      context "with required attribute" do
        let(:expected_response) {
          {
            id: menu_item.id,
            name: 'The Classic',
            description: 'Buns, patties, chopped onions, ketchup, mustard',
            price: 2.19.to_s,
            menus: [ {
              id: menu.id,
              title: menu.title
            } ]
          }
        }

        it "should return the record with new value with status 200" do
          put "/v1/menu_items/#{menu_item.id}", params: {
            name: 'The Classic',
            description: 'Buns, patties, chopped onions, ketchup, mustard',
            price: 2.19
          }

          expect(response.status).to eq(200)
          expect(response.body).to eq(expected_response.to_json)
        end

        context "with name already used" do
          let!(:menu_item) {
            MenuItem.create(
              name: 'The Classic',
              description: 'Buns, patties, chopped onions, ketchup, mustard',
              price: 2.19,
              menu_ids: [ menu.id ]
            )
          }

          let!(:new_menu_item) {
            MenuItem.create(
              name: 'Big Mac',
              description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
              price: 5.69,
              menu_ids: [ menu.id ]
            )
          }

          let(:params) {
            {
              name: 'The Classic',
              description: 'Buns, patties, chopped onions, ketchup, mustard',
              price: 2.19
            }
          }

          it "should return error message with status 422" do
            put "/v1/menu_items/#{new_menu_item.id}", params: params

            expect(response.status).to eq(422)
            expect(response.body).to eq("Validation failed: Name has already been taken")
          end
        end
      end

      context "without params" do
        let(:expected_response) {
          {
            id: menu_item.id,
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69.to_s,
            menus: [ {
              id: menu.id,
              title: menu.title
            } ]
          }
        }

        it "should return specified menu item with status 200" do
          put "/v1/menu_items/#{menu_item.id}"

          expect(response.status).to eq(200)
          expect(response.body).to eq(expected_response.to_json)
        end
      end
    end

    context "without existed id" do
      it "should return error message with status 404" do
        put "/v1/menu_items/999999", params: {
          name: 'The Classic',
          description: 'Buns, patties, chopped onions, ketchup, mustard',
          price: 2.19
        }

        expect(response.status).to eq(404)
        expect(response.body).to eq("Couldn't find MenuItem with 'id'=999999")
      end
    end
  end
end
