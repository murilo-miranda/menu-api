require 'rails_helper'

describe Restaurant, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { is_expected.to have_many(:menus) }
  end
end
