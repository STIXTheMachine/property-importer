json.extract! import_row, :id, :building_name, :street_address, :unit, :city, :state, :zip, :import_id, :created_at, :updated_at
json.url import_row_url(import_row, format: :json)
