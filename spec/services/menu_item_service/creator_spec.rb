require 'rails_helper'

describe MenuItemService::Creator do
  describe ".execute" do
    let!(:menu) { Menu.create(title: 'Burguers') }
    let!(:menu2) { Menu.create(title: 'Lunch') }

    subject { described_class.new(params).execute }

    context "with required attributes" do
      context "for one menu" do
        let(:params) {
          {
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69,
            menu_ids: [ menu.id ]
          }
        }

        it "creates a new menu item associated with a menu" do
          expect { subject }.to change { MenuItem.count }.by 1
          expect(MenuItem.last.menus).to contain_exactly(menu)
        end
      end

      context "for more than one menu" do
        let(:params) {
          {
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69,
            menu_ids: [ menu.id, menu2.id ]
          }
        }

        it "creates a new menu item associated with more than one menu" do
          expect { subject }.to change { MenuItem.count }.by 1
          expect(MenuItem.last.menus).to contain_exactly(menu, menu2)
        end
      end

      context "with name already used" do
        let!(:menu_item) {
          MenuItem.create(
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69,
            menu_ids: [ menu.id ]
          )
        }

        let(:params) {
          {
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69,
            menu_ids: [ menu.id ]
          }
        }

        it "creates a new menu item for menu" do
          expect { subject }.to change { MenuItem.count }.by 1
        end
      end

      context "with non existed menu" do
        let(:params) {
          {
            name: 'Big Mac',
            description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
            price: 5.69,
            menu_ids: [ 999_999 ]
          }
        }

        it "do not creates a new menu item" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context "without required attributes" do
      let(:params) { {} }

      it "do not creates a new menu item for menu" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
