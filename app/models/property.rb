class Property < ApplicationRecord
  has_many :units, dependent: :destroy
end
