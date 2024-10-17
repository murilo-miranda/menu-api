require 'rails_helper'

# frozen_string_literal: true

describe Menu, type: :model do
  context "with parameters" do
    it "creates menu" do
      expect{Menu.create(title: "Burguers")}.to change{Menu.count}.by 1
    end
  end

  context "without parameters" do
    it "do not creates menu" do
      expect{Menu.create()}.to raise_error(ActiveRecord::NotNullViolation)
    end
  end
end
