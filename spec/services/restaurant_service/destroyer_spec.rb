require 'rails_helper'

# frozen_string_literal: true

describe RestaurantService::Destroyer do
  describe ".execute" do
    subject { described_class.new(params).execute }

    let!(:restaurant) { Restaurant.create(name: 'Mc Donalds') }

    context 'existed record' do
      let(:params) { { id: restaurant.id } }

      it "deletes informed restaurant" do
        expect { subject }.to change { Restaurant.count }.from(1).to(0)
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
