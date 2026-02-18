class PropertyImportService < ApplicationService
  require("csv")

  def initialize(file)
    @file = file
  end

  def call
    import = Import.new(filename: @file.original_filename)
    import.save
    puts import.inspect
    csv = CSV.read(@file, headers: true)

    csv.each_with_index do |row, index|

      # Convert header names to the appropriate column names for ImportRow
      row_hash = row.to_hash.each_with_object({}) do |(k, v), h|
        col = k.downcase.sub(" ", "_")
        h[col] = v
      end

      record = ImportRow.new(row_hash)
      record.import_id = import.id
      record.save
      record.broadcast_append_to "import_visitors"
    end
  end
end
