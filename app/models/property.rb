class Property < ApplicationRecord
  has_many :units, dependent: :destroy
  validates :building_name, presence: true, uniqueness: true
end
