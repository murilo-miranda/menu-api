require 'rails_helper'

describe MenuItem, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
  end

  describe "association" do
    it { should belong_to(:menu) }
  end
end
