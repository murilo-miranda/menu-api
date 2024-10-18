require 'rails_helper'

# frozen_string_literal: true

describe Menu, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
  end

  describe "associations" do
    it { is_expected.to have_many(:menu_items) }
  end
end
