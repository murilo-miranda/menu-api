class Menu < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  validates :title, presence: true
end
