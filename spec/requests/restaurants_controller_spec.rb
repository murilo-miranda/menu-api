require 'rails_helper'

describe "Restaurants", type: :request do
  context "POST /v1/restaurants" do
    context "with required attribute" do
      context "and with menu association" do
        let!(:menu) { Menu.create(title: "Burguers") }

        let(:expected_response) {
          {
            id: Restaurant.last.id,
            name: Restaurant.last.name,
            menus: [
              {
                id: menu.id,
                title: menu.title
              }
            ]
          }
        }

        it "should return created restaurants with menu association and status 201" do
          post '/v1/restaurants', params: {
            name: "Mc Donalds",
            menu_ids: [ menu.id ]
          }

          expect(response.status).to eq(201)
          expect(response.body).to eq(expected_response.to_json)
        end
      end

      context "and without menu association" do
        let!(:menu) { Menu.create(title: "Burguers") }

        let(:expected_response) {
          {
            id: Restaurant.last.id,
            name: Restaurant.last.name,
            menus: []
          }
        }

        it "should return created restaurants with menu association and status 201" do
          post '/v1/restaurants', params: {
            name: "Mc Donalds"
          }

          expect(response.status).to eq(201)
          expect(response.body).to eq(expected_response.to_json)
        end
      end
    end

    context "without required attribute" do
      it "should return error message with status 422 " do
        post '/v1/restaurants'

        expect(response.status).to eq(422)
        expect(response.body).to eq("Validation failed: Name can't be blank")
      end
    end
  end

  context "DELETE /v1/restaurants/:id" do
    context "with existed id" do
      let!(:restaurant) { Restaurant.create(name: 'Mc Donalds') }

      it "should return empty body with status 204" do
        delete "/v1/restaurants/#{restaurant.id}"

        expect(response.status).to eq(204)
        expect(response.body).to eq("")
      end
    end

    context "with non existed id" do
      let!(:restaurant) { Restaurant.create(name: 'Mc Donalds') }

      it "should return empty body with status 204" do
        delete "/v1/restaurants/999999"

        expect(response.status).to eq(404)
        expect(response.body).to eq("Couldn't find Restaurant with 'id'=999999")
      end
    end
  end

  context "GET /v1/restaurants/:id" do
    let!(:restaurant) { Restaurant.create(name: 'Mc Donalds') }

    context "with existed id" do
      let(:expected_response) {
        {
          id: restaurant.id,
          name: restaurant.name
        }
      }

      it "should return the restaurant record with status 200" do
        get "/v1/restaurants/#{restaurant.id}"

        expect(response.status).to eq(200)
        expect(response.body).to be_json.with_content(expected_response)
      end
    end

    context "without existed id" do
      it "should return error message with status 404" do
        get "/v1/restaurants/999999"

        expect(response.status).to eq(404)
        expect(response.body).to eq("Couldn't find Restaurant with 'id'=999999")
      end
    end
  end

  context "PUT /v1/restaurants/:id" do
    context "with existed id" do
      context "with required attribute" do
        let!(:restaurant) { Restaurant.create(name: 'Mc Donalds') }
        let(:expected_response) {
          {
            id: restaurant.id,
            name: restaurant.reload.name
          }
        }

        it "should return the record with new value with status 200" do
          put "/v1/restaurants/#{restaurant.id}", params: {
            name: "Burguer King"
          }

          expect(response.status).to eq(200)
          expect(response.body).to be_json.with_content(expected_response)
        end
      end

      context "without required attribute" do
        let!(:restaurant) { Restaurant.create(name: 'Mc Donalds') }

        it "should return the record with new value with status 422" do
          put "/v1/restaurants/#{restaurant.id}"

          expect(response.status).to eq(422)
          expect(response.body).to eq("Validation failed: Name can't be blank")
        end
      end
    end

    context "without existed id" do
      let!(:restaurant) { Restaurant.create(name: 'Mc Donalds') }

      it "should return error message with status 404" do
        put "/v1/restaurants/999999", params: {
          name: "Burguer King"
        }

        expect(response.status).to eq(404)
        expect(response.body).to eq("Couldn't find Restaurant with 'id'=999999")
      end
    end
  end

  context "GET /v1/restaurants" do
    context "without menus" do
      let!(:restaurant) { Restaurant.create(name: "Mc Donalds") }
      let!(:restaurant2) { Restaurant.create(name: "Burguer King") }
      let(:expected_response) {
        [
          {
            id: restaurant.id,
            name: restaurant.name,
            menus: []
          },
          {
            id: restaurant2.id,
            name: restaurant2.name,
            menus: []
          }
        ]
      }

      it "should return restaurant collection with status 200" do
        get "/v1/restaurants"

        expect(response.status).to eq(200)
        expect(response.body).to eq (expected_response.to_json)
      end
    end

    context "with menus" do
      let!(:restaurant) { Restaurant.create(name: "Mc Donalds", menu_ids: [ menu.id ]) }
      let!(:restaurant2) { Restaurant.create(name: "Burguer King") }
      let!(:menu) { Menu.create(title: 'Burguers') }

      let(:expected_response) {
        [
          {
            id: restaurant.id,
            name: restaurant.name,
            menus: [
              {
                id: menu.id,
                title: menu.title
              }
            ]
          },
          {
            id: restaurant2.id,
            name: restaurant2.name,
            menus: []
          }
        ]
      }

      it "should return restaurant collection with menus and status 200" do
        get "/v1/restaurants"

        expect(response.status).to eq(200)
        expect(response.body).to eq (expected_response.to_json)
      end
    end
  end
end
