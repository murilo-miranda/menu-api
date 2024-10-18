require 'rails_helper'

# frozen_string_literal: true

describe MenuService::Editor do
  describe ".execute" do
    let!(:menu) { Menu.create(title: "Burguers") }

    context "existed record" do
      context "with required params" do
        subject { described_class.new(params).execute }
        
        let(:params) {
          {
            id: menu.id,
            title: "Pasta"
          }
        }
        
        it "updates informed menu" do
          subject
          expect(menu.reload.id).to eq(params.fetch(:id))
          expect(menu.reload.title).to eq("Pasta")
        end
      end

      context "without required title params" do
        subject { described_class.new(params).execute }
        
        let(:params) {
          {
            id: menu.id,
          }
        }
        
        it "do not updates informed menu" do
          expect{ subject }.to raise_error(ActiveRecord::RecordInvalid)
          expect(menu.reload.id).to eq(params.fetch(:id))
          expect(menu.reload.title).to eq("Burguers")
        end
      end
    end

    context "non existed record" do
      subject { described_class.new(params).execute }

      let(:params) {
        {
          id: 999_999,
          title: "Pasta"
        }
      }
      
      it "updates informed menu" do
        expect{ subject }.to raise_error(ActiveRecord::RecordNotFound)
        expect(menu.reload.title).to eq("Burguers")
      end
    end
  end
end
