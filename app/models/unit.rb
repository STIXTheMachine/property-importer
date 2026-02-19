class Unit < ApplicationRecord
  belongs_to :property
  validates :number, presence: true, uniqueness: { scope: :property_id, message: "Unit already exists for this property." }
end
