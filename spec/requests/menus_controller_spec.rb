require 'rails_helper'

# frozen_string_literal: true

describe "Menus", type: :request do
  context "POST v1/menus" do
    context "with params" do
      let(:expected_response) {
        {
          id: Menu.last.id,
          title: Menu.last.title
        }
      }

      it "should return created menu with status 201" do
        post '/v1/menus', params: {
          title: "Burguers"
        }

        expect(response.status).to eq(201)
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context "without params" do
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
end
