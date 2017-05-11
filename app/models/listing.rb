# == Schema Information
#
# Table name: listings
#
#  id                  :integer          not null, primary key
#  sysid               :integer
#  listing_id          :integer
#  property_type       :string
#  property_tax        :string
#  price               :integer
#  original_list_price :integer
#  living_area         :integer
#  beds                :integer
#  baths               :integer
#  half_baths          :integer
#  garage              :boolean          default(FALSE)
#  description         :text
#  state               :string
#  city                :string
#  street              :string
#  full_street         :string
#  image               :string
#  year_built          :string
#  source              :integer          default("realtor")
#  url                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Listing < ApplicationRecord
  URL = 'http://www.realtor.com/'
  # enum property_type: [:"Single Family"]
  enum source: [:realtor, :reso]

  mount_uploader :image, ListingImageUploader

  def full_address
    [full_street, city, state].reject(&:blank?).map(&:capitalize).join(' ')
  end
end
