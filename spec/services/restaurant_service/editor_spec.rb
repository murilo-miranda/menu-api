require 'rails_helper'

# frozen_string_literal: true

describe RestaurantService::Editor do
  describe ".execute" do
    let!(:restaurant) { Restaurant.create(name: "Mc Donalds") }

    context "existed record" do
      context "with required params" do
        subject { described_class.new(params).execute }

        let(:params) {
          {
            id: restaurant.id,
            name: "Burguer King"
          }
        }

        it "updates informed restaurant" do
          subject
          expect(restaurant.reload.id).to eq(params.fetch(:id))
          expect(restaurant.reload.name).to eq("Burguer King")
        end
      end

      context "without required name params" do
        subject { described_class.new(params).execute }

        let(:params) {
          {
            id: restaurant.id
          }
        }

        it "do not updates informed restaurant" do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
          expect(restaurant.reload.id).to eq(params.fetch(:id))
          expect(restaurant.reload.name).to eq("Mc Donalds")
        end
      end
    end

    context "non existed record" do
      subject { described_class.new(params).execute }

      let(:params) {
        {
          id: 999_999,
          name: "Burguer King"
        }
      }

      it "updates informed restaurant" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        expect(restaurant.reload.name).to eq("Mc Donalds")
      end
    end
  end
end
