require 'rails_helper'

# frozen_string_literal: true

describe MenuItemService::Editor do
  describe ".execute" do
    let!(:menu) { Menu.create(title: "Burguers") }
    let!(:menu_item) {
      MenuItem.create(
        name: 'Big Mac',
        description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
        price: 5.69,
        menu_id: menu.id
      )
    }

    context "existed record" do
      context "with required params" do
        subject { described_class.new(params).execute }

        let(:params) {
          {
            id: menu_item.id,
            name: 'The Classic',
            description: 'Buns, patties, chopped onions, ketchup, mustard',
            price: 2.19,
            menu_id: menu.id
          }
        }

        it "updates informed menu" do
          subject
          expect(menu_item.reload.id).to eq(params.fetch(:id))
          expect(menu_item.reload.name).to eq("The Classic")
          expect(menu_item.reload.description).to eq("Buns, patties, chopped onions, ketchup, mustard")
          expect(menu_item.reload.price).to eq(2.19)
        end
      end

      context "without required params" do
        subject { described_class.new(params).execute }

        let(:params) {
          {
            id: menu_item.id
          }
        }

        it "do not updates informed menu" do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
          expect(menu_item.reload.id).to eq(params.fetch(:id))
          expect(menu_item.reload.name).to eq("Big Mac")
        end
      end
    end

    context "non existed record" do
      subject { described_class.new(params).execute }

      let(:params) {
        {
          id: 999_999,
          name: 'The Classic',
          description: 'Buns, patties, chopped onions, ketchup, mustard',
          price: 2.19,
          menu_id: menu.id
        }
      }

      it "do not updates informed menu" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        expect(menu_item.reload.name).to eq("Big Mac")
        expect(menu_item.reload.description).to eq("Buns, patties, cheese, lettuce pickles, onions, sauce, paprika")
        expect(menu_item.reload.price).to eq(5.69)
      end
    end
  end
end
