
# Service responsible for importing data from a CSV file and turning it into an Import object for review and validation
# prior to submitting to the DB
class ImportFromCSVService < ApplicationService
  require("csv")

  def initialize(file)
    @file = file
  end

  def call

    # Create new import record
    import = Import.new(filename: @file.original_filename)
    import.save

    # Read CSV file
    csv = CSV.read(@file, headers: true)

    # Loop, save, associate with import object
    csv.each_with_index do |row, index|

      # Convert header names to the appropriate column names for ImportRow
      row_hash = row.to_hash.each_with_object({}) do |(k, v), h|
        col = k.downcase.sub(" ", "_")
        h[col] = v
      end

      record = ImportRow.new(row_hash)
      record.normalize_fields!
      record.import_id = import.id
      record.save
    end

    # Return a reference to the import object we just created
    import
  end
end
