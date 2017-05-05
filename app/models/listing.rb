class Listing < ApplicationRecord
  URL = 'http://www.realtor.com/'
  # enum property_type: [:"Single Family"]
  enum source: [:realtor, :reso]

  mount_uploader :image, ListingImageUploader

  def full_address
    [full_street, city, state].reject(&:blank?).map(&:capitalize).join(' ')
  end
end
