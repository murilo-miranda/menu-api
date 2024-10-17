require 'rails_helper'

# frozen_string_literal: true

describe MenuService::Destroyer do
  describe ".execute" do
    subject { described_class.new(params).execute }

    let!(:menu) { Menu.create(title: 'Burguers') }

    context 'existed record' do
      let(:params) { { id: menu.id } }

      it "deletes informed menu" do
        expect { subject }.to change { Menu.count }.from(1).to(0)
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
