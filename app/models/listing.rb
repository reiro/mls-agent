class Listing < ApplicationRecord
  # enum property_type: [:"Single Family"]
  enum source: [:realtor, :reso]

  def full_address
    [full_street, city, state].reject(&:blank?).map(&:capitalize).join(' ')
  end
end
