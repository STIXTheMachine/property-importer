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
      record = ImportRow.new(row.to_hash)
      record.import_id = import.id
      record.save
      record.broadcast_append_to "import_visitors"
    end
  end
end
