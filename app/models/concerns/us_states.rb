module UsStates
STATE_CODES = [
  # Regular 50 States
  "AL",
  "AK",
  "AZ",
  "AR",
  "CA",
  "CO",
  "CT",
  "DE",
  "FL",
  "GA",
  "HI",
  "ID",
  "IL",
  "IN",
  "IA",
  "KS",
  "KY",
  "LA",
  "ME",
  "MD",
  "MA",
  "MI",
  "MN",
  "MS",
  "MO",
  "MT",
  "NE",
  "NV",
  "NH",
  "NJ",
  "NM",
  "NY",
  "NC",
  "ND",
  "OH",
  "OK",
  "OR",
  "PA",
  "RI",
  "SC",
  "SD",
  "TN",
  "TX",
  "UT",
  "VT",
  "VA",
  "WA",
  "WV",
  "WI",
  "WY",

  # Special "states"
  "DC", # District of Columbia
  "GU", # Guam
  "MH", # Marshall Islands
  "PR", # Puerto Rico
  "VI"  # Virgin Islands
].freeze

# c.f. ImportRow#normalize_state
STATE_NAMES_TO_STATE_CODES = {
  # Regular 50 States
  "ALABAMA"        => "AL",
  "ALASKA"         => "AK",
  "ARIZONA"        => "AZ",
  "ARKANSAS"       => "AR",
  "CALIFORNIA"     => "CA",
  "COLORADO"       => "CO",
  "CONNECTICUT"    => "CT",
  "DELAWARE"       => "DE",
  "FLORIDA"        => "FL",
  "GEORGIA"        => "GA",
  "HAWAII"         => "HI",
  "IDAHO"          => "ID",
  "ILLINOIS"       => "IL",
  "INDIANA"        => "IN",
  "IOWA"           => "IA",
  "KANSAS"         => "KS",
  "KENTUCKY"       => "KY",
  "LOUISIANA"      => "LA",
  "MAINE"          => "ME",
  "MARYLAND"       => "MD",
  "MASSACHUSETTS"  => "MA",
  "MICHIGAN"       => "MI",
  "MINNESOTA"      => "MN",
  "MISSISSIPPI"    => "MS",
  "MISSOURI"       => "MO",
  "MONTANA"        => "MT",
  "NEBRASKA"       => "NE",
  "NEVADA"         => "NV",
  "NEW HAMPSHIRE"  => "NH",
  "NEW JERSEY"     => "NJ",
  "NEW MEXICO"     => "NM",
  "NEW YORK"       => "NY",
  "NORTH CAROLINA" => "NC",
  "NORTH DAKOTA"   => "ND",
  "OHIO"           => "OH",
  "OKLAHOMA"       => "OK",
  "OREGON"         => "OR",
  "PENNSYLVANIA"   => "PA",
  "RHODE ISLAND"   => "RI",
  "SOUTH CAROLINA" => "SC",
  "SOUTH DAKOTA"   => "SD",
  "TENNESSEE"      => "TN",
  "TEXAS"          => "TX",
  "UTAH"           => "UT",
  "VERMONT"        => "VT",
  "VIRGINIA"       => "VA",
  "WASHINGTON"     => "WA",
  "WEST VIRGINIA"  => "WV",
  "WISCONSIN"      => "WI",
  "WYOMING"        => "WY",

  # Special "states"
  "DISTRICT OF COLUMBIA" => "DC", # District of Columbia
  "GUAM"                 => "GU", # Guam
  "MARSHALL ISLANDS"     => "MH", # Marshall Islands
  "PUERTO RICO"          => "PR", # Puerto Rico
  "US VIRGIN ISLANDS"    => "VI"  # Virgin Islands
}.freeze
end
