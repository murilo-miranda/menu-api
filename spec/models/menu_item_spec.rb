require 'rails_helper'

describe MenuItem, type: :model do
  let!(:menu) { Menu.create(title: 'Burguers') }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    subject { MenuItem.new(name: 'Big Mac', price: 5.69, menu_id: menu.id) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "association" do
    it { should belong_to(:menu) }
  end
end
