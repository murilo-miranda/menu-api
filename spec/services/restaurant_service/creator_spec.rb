require 'rails_helper'

# frozen_string_literal: true

describe RestaurantService::Creator do
  describe ".execute" do
    subject { described_class.new(params).execute }

    context "with required attributes" do
      let(:params) {
        {
          name: 'Mc Donalds'
        }
      }

      it "creates a new restaurant" do
        expect { subject }.to change { Restaurant.count }.by 1
      end
    end

    context "without required attributes" do
      let(:params) { {} }

      it "do not creates a new restaurant" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
