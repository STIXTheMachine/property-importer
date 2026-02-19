# Service responsible for reviewing an Import object and determining if there are any issues which should be brought
# to attention/fixed
class ValidateImportService < ApplicationService
  def initialize(import)
    @import = import
  end
  def call
    @errors = []
    @validations_passed = true

    run_validations
    @import.validated = @validations_passed
    @import.save

    # Return result of validation
    if @validations_passed
      { success: true }
    else
      { success: false, errors: @errors }
    end
  end

  private

  def run_validations
    validate_properties_not_already_in_db
    validate_states
    validate_zip_codes
  end

  # Since we are only ingesting NEW properties we want to make sure that we are not clobbering any Properties already in the DB
  def validate_properties_not_already_in_db
    seen = Set.new
    properties = []

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

      # Check if we have any Properties already in the DB
      properties_already_in_db = Property
                          .where(building_name: properties.map { |p| p[:building_name] })

      @validations_passed &= properties_already_in_db.empty?

    unless @validations_passed
      properties_already_in_db.each do | property |
        @errors << "Property #{property[:building_name]} already exists in DB"
      end
    end
  end

  def validate_states
    @import.import_rows.each do | row |
      unless UsStates::STATE_CODES.include?(row.state)
        @validations_passed &= false
        @errors << "State #{row[:state]} is not a valid state code"
      end
    end
  end


  # We only do very basic tests here because you can't really fully validate a zip code without calling to some API
  # or maintaining a list of over 44,000 entries
  def validate_zip_codes
    @import.import_rows.each do | row |

      # Check that zip_code could even conceivably be a zip code
      unless row.zip_code.match?(/^\d{5}$/)
        @validations_passed &= false
        @errors << "#{row[:zip_code]} is not a valid zip code"
      end

      if %w[00000 11111 12345 99999].include?(row.zip_code)
        @validations_passed &= false
        @errors << "#{row[:zip_code]} is not a valid zip code"
      end
    end
  end
end
