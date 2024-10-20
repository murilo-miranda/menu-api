require 'rails_helper'

# frozen_string_literal: true

describe MenuItemService::Destroyer do
  describe ".execute" do
    subject { described_class.new(params).execute }

    let!(:menu) { Menu.create(title: 'Burguers') }
    let!(:menu_item) {
      MenuItem.create(
        name: 'Big Mac',
        description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
        price: 5.69,
        menu_ids: [ menu.id ]
      )
    }

    context 'existed record' do
      let(:params) { { id: menu_item.id } }

      it "deletes informed menu item" do
        expect { subject }.to change { MenuItem.count }.from(1).to(0)
      end
    end

    context 'non existed record' do
      let(:params) { { id: 999_999 } }

      it "raises ActiveRecord::RecordNotFound" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
