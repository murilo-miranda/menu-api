require 'rails_helper'

# frozen_string_literal: true

describe MenuItemService::Editor do
  describe ".execute" do
    let(:old_name) { 'Big Mac' }
    let(:old_description) { 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika' }
    let(:old_price) { 5.69 }
    let(:old_menu_ids) { [ menu.id ] }
    let(:old_menus) { menu }
    let(:new_name) { 'The Classic' }
    let(:new_description) { 'Buns, patties, chopped onions, ketchup, mustard' }
    let(:new_price) { 2.19 }
    let(:new_menu_ids) { [ menu2.id ] }
    let(:new_menus) { menu2 }

    let!(:menu) { Menu.create(title: "Burguers") }
    let!(:menu2) { Menu.create(title: "Lunch") }
    let!(:menu_item) {
      MenuItem.create(
        name: old_name,
        description: old_description,
        price: old_price,
        menu_ids: old_menu_ids
      )
    }

    subject { described_class.new(params).execute }

    context "existed menu item" do
      context "with all params" do
        let(:params) {
          {
            id: menu_item.id,
            name: new_name,
            description: new_description,
            price: new_price,
            menu_ids: new_menu_ids
          }
        }

        it "updates informed menu item" do
          subject
          expect(menu_item.reload.id).to eq(params.fetch(:id))
          expect(menu_item.reload.name).to eq(new_name)
          expect(menu_item.reload.description).to eq(new_description)
          expect(menu_item.reload.price).to eq(new_price)
          expect(menu_item.reload.menus).to contain_exactly(new_menus)
        end

        context "with name already used" do
          let!(:new_menu_item) {
            MenuItem.create(
              name: 'The Classic',
              description: 'Buns, patties, chopped onions, ketchup, mustard',
              price: 2.19
            )
          }

          let(:params) {
            {
              id: new_menu_item.id,
              name: 'Big Mac',
              description: 'Buns, patties, cheese, lettuce pickles, onions, sauce, paprika',
              price: 5.69
            }
          }

          it "do not updates informed menu" do
            expect(new_menu_item.reload.id).to eq(params.fetch(:id))
            expect(new_menu_item.reload.name).to eq("The Classic")
            expect(new_menu_item.reload.description).to eq("Buns, patties, chopped onions, ketchup, mustard")
            expect(new_menu_item.reload.price).to eq(2.19)
          end
        end
      end

      context "with only params" do
        context 'name' do
          let(:params) {
            {
              id: menu_item.id,
              name: 'New name'
            }
          }

          it "only updates the name of informed menu item" do
            subject
            expect(menu_item.reload.id).to eq(params.fetch(:id))
            expect(menu_item.reload.name).to eq("New name")
            expect(menu_item.reload.description).to eq(old_description)
            expect(menu_item.reload.price).to eq(old_price)
            expect(menu_item.reload.menus).to contain_exactly(old_menus)
          end
        end

        context 'description' do
          let(:params) {
            {
              id: menu_item.id,
              description: new_description
            }
          }

          it "only updates the description of informed menu item" do
            subject
            expect(menu_item.reload.id).to eq(params.fetch(:id))
            expect(menu_item.reload.name).to eq(old_name)
            expect(menu_item.reload.description).to eq(new_description)
            expect(menu_item.reload.price).to eq(old_price)
            expect(menu_item.reload.menus).to contain_exactly(old_menus)
          end
        end

        context 'price' do
          let(:params) {
            {
              id: menu_item.id,
              price: new_price
            }
          }

          it "only updates the price of informed menu item" do
            subject
            expect(menu_item.reload.id).to eq(params.fetch(:id))
            expect(menu_item.reload.name).to eq(old_name)
            expect(menu_item.reload.description).to eq(old_description)
            expect(menu_item.reload.price).to eq(new_price)
            expect(menu_item.reload.menus).to contain_exactly(old_menus)
          end
        end

        context 'menu_ids' do
          let(:params) {
            {
              id: menu_item.id,
              menu_ids: new_menu_ids
            }
          }

          it "only updates the menu_ids of informed menu item" do
            subject
            expect(menu_item.reload.id).to eq(params.fetch(:id))
            expect(menu_item.reload.name).to eq(old_name)
            expect(menu_item.reload.description).to eq(old_description)
            expect(menu_item.reload.price).to eq(old_price)
            expect(menu_item.reload.menus).to contain_exactly(new_menus)
          end
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
