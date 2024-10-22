require 'rails_helper'

RSpec.describe ImportService do
  describe '#execute' do
    let(:json_data) { File.read('spec/fixtures/restaurant_data.json') }
    let(:import_service) { ImportService.new(JSON.parse(json_data)) }

    it 'imports restaurants' do
      expect { import_service.execute }.to change(Restaurant, :count).by(2)
    end

    it 'imports menus' do
      expect { import_service.execute }.to change(Menu, :count).by(4)
    end

    it 'imports menu items' do
      expect { import_service.execute }.to change(MenuItem, :count).by(8)
    end

    it 'associates menus with restaurants' do
      import_service.execute
      restaurant = Restaurant.first
      expect(restaurant.menus.count).to eq(2)
    end

    it 'associates menu items with menus' do
      import_service.execute
      menu = Menu.first
      expect(menu.menu_items.count).to eq(2)
    end

    context 'with invalid data' do
      let(:json_data) { File.read('spec/fixtures/invalid_restaurant_data.json') }

      it 'raises an error' do
        expect { import_service.execute }.to raise_error(StandardError)
      end
    end
  end
end