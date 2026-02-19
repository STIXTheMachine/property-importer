class ImportRow < ApplicationRecord
  belongs_to :import

  # We normalize all of our data into a consistent form to assist with catching potential duplicates
  def normalize_fields!
    normalize_building_name!
    normalize_street_address!
    normalize_city!
    normalize_state!
    normalize_zip!
  end

  private

  # =================================
  # ==== Normalization Functions ====
  # =================================

  def normalize_string_value(string)
    string.to_s.squish.upcase.gsub(/[[:punct:]]/, "")
  end

  def normalize_building_name!
    return if building_name.blank?
    normalized = normalize_string_value(building_name)
    self.building_name = normalized
  end

  def normalize_street_address!
    return if street_address.blank?
    normalized = normalize_string_value(street_address)
    self.street_address = normalized
  end

  def normalize_city!
    return if city.blank?
    normalized = normalize_string_value(city)
    self.city = normalized
  end

  def normalize_state!
    return if state.blank?

    # Perform regular string normalization and assign before we try to convert it to a state code
    normalized = normalize_string_value(state)
    self.state = normalized

    # If state is already a valid 2 letter state code, we're done
    if UsStates::STATE_CODES.include?(normalized)
      return
    end

    # Fix up common abbreviations like "N CAROLINA"
    # Don't forget the trailing spaces!!
    if normalized.include?("N ")
      normalized.sub!("N ", "NORTH ")
    elsif normalized.include?("NO ")
      normalized.sub!("NO ", "NORTH ")

    elsif normalized.include?("S ")
      normalized.sub!("S ", "SOUTH ")
    elsif normalized.include?("SO")
      normalized.sub!("SO", "SOUTH ")

    elsif normalized.include?("W ")
      normalized.sub!("W ", "WEST ")
    elsif normalized.include?("WE ")
      normalized.sub!("WE ", "WEST ")
    end

    # Attempt to convert normalized state name to 2 letter state code
    if UsStates::STATE_NAMES_TO_STATE_CODES.key?(normalized)
      self.state = UsStates::STATE_NAMES_TO_STATE_CODES[normalized]
    end
  end

  def normalize_zip!
    return if zip_code.blank?
    # Really not much we can do other than trim whitespace and strip the +4 if it's present
    normalized = zip_code.to_s.squish.slice(0, 5)
    self.zip_code = normalized
  end
end
