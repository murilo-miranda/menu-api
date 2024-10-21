require 'rails_helper'

# frozen_string_literal: true

describe MenuService::Creator do
  describe ".execute" do
    subject { described_class.new(params).execute }

    context "with required attributes" do
      let(:params) {
        {
          title: 'Burguers'
        }
      }

      it "creates a new menu" do
        expect { subject }.to change { Menu.count }.by 1
      end
    end

    context "without required attributes" do
      let(:params) { {} }

      it "do not creates a new menu" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "with non existed restaurant/menu_item" do
      let(:params) {
        {
          title: 'Burguers',
          menu_item_ids: [ 999_999 ],
          restaurant_ids: [ 999_999 ]
        }
      }

      it "do not creates a new menu item" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
