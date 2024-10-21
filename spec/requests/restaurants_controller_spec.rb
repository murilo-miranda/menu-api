require 'rails_helper'

describe "Restaurants", type: :request do
  context "POST /v1/restaurants" do
    context "with params" do
      let(:expected_response) {
        {
          id: Restaurant.last.id,
          name: Restaurant.last.name
        }
      }

      it "should return created restaurants with status 201" do
        post '/v1/restaurants', params: {
          name: "Mc Donalds"
        }

        expect(response.status).to eq(201)
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context "without params" do
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
end
