class PropertyImportService < ApplicationService
  require("csv")

  def initialize(model, file)
    @model = model
    @file = file
  end

  def call
    csv = CSV.read(@file, headers: true)

    csv.each_with_index do |row, index|
      @record = @model.new(row.to_hash)
      @record.save
      @record.broadcast_append_to "import_visitors"
    end
  end
end
