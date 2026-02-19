# Service responsible for parsing data stored in an Import object, converting it to Properties and Units, and saving them
# to the DB. Assumes data has already been validated.
class PropertiesAndUnitsFromImportService < ApplicationService
  def initialize(import)
    @import = import
  end

  def call
    require("set")

    seen = Set.new
    properties = []
    units = []

    # Collect and deduplicate Properties
    @import.import_rows.each do | row |
      key = [
        row.building_name,
        row.street_address,
        row.city,
        row.state,
        row.zip_code
      ]

      next if seen.include? key

      seen.add key

      properties << {
        building_name: row.building_name,
        street_address: row.street_address,
        city: row.city,
        state: row.state,
        zip_code: row.zip_code
      }
    end

    # Bulk insert
    Property.transaction do
      Property.insert_all(properties)
    end
  end
end
