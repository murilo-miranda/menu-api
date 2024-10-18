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
          menu_id: MenuItem.last.menu_id
        }
      }

      it "should return created menu item with status 201" do
        post '/v1/menu_items', params: {
          name: 'Big Mac',
          description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
          price: 5.69,
          menu_id: menu.id
        }

        expect(response.status).to eq(201)
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context "without params" do
      it "should return error message with status 422 " do
        post '/v1/menu_items', params: {}

        expect(response.status).to eq(422)
        expect(response.body).to eq("Validation failed: Menu must exist, Name can't be blank, Price can't be blank")
      end
    end
  end
end
