class Import < ApplicationRecord
  has_many :import_rows, dependent: :destroy
end
