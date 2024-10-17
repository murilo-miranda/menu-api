require 'rails_helper'

# frozen_string_literal: true

describe "Menus", type: :request do
  context "POST /create" do
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
end
