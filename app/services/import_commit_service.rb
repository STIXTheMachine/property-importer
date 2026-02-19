# Service responsible for parsing data stored in an Import object, converting it to Properties and Units, and saving them
# to the DB. Will only commit data if the Import has been marked as validated by the ImportValidationService
class ImportCommitService < ApplicationService
  def initialize(import)
    @import = import
  end

  def call

    unless @import.validated?
      return { success: false, message: "Commit unsuccessful: import has not passed validation. No data has been sent to the DB. Please run validation and try again." }
    end

    if @import.committed?
      return { success: false, message: "Commit unsuccessful: this Import has already been committed to the DB." }
    end

    require("set")

    seen = Set.new
    properties = []
    units = []

    # Collect and deduplicate Properties
    @import.import_rows.each do | row |
      property_key = [
        row.building_name,
        row.street_address,
        row.city,
        row.state,
        row.zip_code
      ]

      next if seen.include? property_key

      seen.add property_key

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

    # Extract the DB records for all of the properties we just inserted so we can grab the IDs
    property_lookup = Property
                        .where(building_name: properties.map { |p| p[:building_name] })
                        .index_by(&:building_name)

    # Loop over rows, extract unit numbers, assign to properties
    @import.import_rows.each do | row |
      units << {
        number: row.unit,
        property_id: property_lookup[row.building_name].id
      }

    end

    # Bulk insert
    Unit.transaction do
      Unit.insert_all(units)
    end

    # Mark as successfully committed
    @import.committed = true
    @import.save

    { success: true, message: "Import successfully committed!" }
  end
end
