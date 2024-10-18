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
      let(:expected_response) {
        {
          id: menu.id,
          title: menu.title
        }
      }

      it "should return the menu record with status 200" do
        get "/v1/menus/#{menu.id}"

        expect(response.status).to eq(200)
        expect(response.body).to be_json.with_content(expected_response)
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
end
