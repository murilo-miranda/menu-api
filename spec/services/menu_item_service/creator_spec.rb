require 'rails_helper'

describe MenuItemService::Creator do
  describe ".execute" do
    let!(:menu) { Menu.create(title: 'Burguers') }

    subject { described_class.new(params).execute }

    context "with required attributes" do
      let(:params) {
        {
          name: 'Big Mac',
          description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
          price: 5.69,
          menu_id: menu.id
        }
      }

      it "creates a new menu item for menu" do
        expect { subject }.to change { MenuItem.count }.by 1
      end

      context "with name already used" do
        let!(:menu_item) {
          MenuItem.create(
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69,
            menu_id: menu.id
          )
        }

        let(:params) {
          {
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69,
            menu_id: menu.id
          }
        }

        it "do not creates a new menu item for menu" do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context "without required attributes" do
      let(:params) { { menu_id: menu.id } }

      it "do not creates a new menu item for menu" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
