require 'rets'

class ResoParser
  attr_accessor :rets_client, :listings, :raw_listings, :parsed_listings

  id_attrs = %i(sysid ListingID RESOPropertyType PropertyTypeStandardName PropertyTypeDescription PropertyTax PropertySubTypeDescription)

  price_attrs = %i(ListPrice ListPricePrevious OriginalListPrice)

  area_attrs = %i(LivingArea LotSizeAreaAcres LotSizeAreaSqFeet
  RoomsBasementArea)

  rooms_attrs = %i(RoomsTotalRooms TotalUnits ParkingTotal Beds BathsFull BathsHalf)

  garage_attrs = %i(GarageSpaces GarageAttachedYN GarageYN)

  building_attrs = %i(Floors Roof Construction Material)

  desc_attrs = %i(PublicRemarks LotDesc ListingAreaDescription ViewDescription)

  address_attrs = %i(AddressState AddressCounty AddressCountry MapCoordinate
  AddressCity AddressStreetAddress AddressStreetName)

  other_attrs = %i(PoolPresent CoolingPresent Cooling Fencing)

  schools_attrs = %i(SchoolElementarySchool SchoolHighSchool SchoolJrHigh
  SchoolMiddleSchool SchoolSchoolDistrict SchoolElementaryDistrict)

  ALL = {
      ids: id_attrs, price: price_attrs, area: area_attrs, rooms: rooms_attrs,
      garage: garage_attrs, building: building_attrs, desc: desc_attrs,
      address: address_attrs, school: schools_attrs, other: other_attrs
  }

  metadata_cache = Rets::Metadata::FileCache.new("/tmp/metadata")
  RESO_CREDS = {
      login_url: 'http://agdb.rets.interealty.com/Login.asmx/Login',
      username: 'ACTRISBETA1',
      password: '1BetaOne',
      version: 'RETS/1.0.2',
      agent: 'ACTRISIDX/1.0',
      ua_password: '321654',
      metadata_cache: metadata_cache
  }

  def parse_attrs_group(listing, attrs_set)
    attrs_set.each_with_object({}) { |a, res| res[a] = listing[a.to_s] }
  end

  def parse_listing(listing)
    ALL.each_with_object({}) do |a, res|
      res[a[0]] = parse_attrs_group(listing, a[1])
    end
  end

  def initialize
    @listings = []
    @raw_listings = []
    @parsed_listings = []
    @rets_client = Rets::Client.new(RESO_CREDS)
    login
  end

  def login
    begin
      @rets_client.login
    rescue => e
      puts 'Error: ' + e.message
      exit!
    end
  end

  def parse
    parse_all_states
    save_listings
  end

  def get_listings(query='(ListPrice=1+)')
    begin
      @listings = @rets_client.find :all, {
          search_type: 'Property',
          class: 'property',
          standard_names: 'DataDictionary:1.4',
          query: query,
          limit: 500
      }
      parse_raw(@listings)
    rescue => e
      puts 'Error: ' + e.message
    end
  end

  def parse_raw(listings)
    listings.each_with_index do |listing, i|
      parsed_listing = parse_listing(listing)
      @raw_listings << parsed_listing# unless rooms["TotalUnits"].empty?
    end
  end

  def to_boolean(str)
    str == 'Y'
  end

  def save_listings
    @raw_listings.each do |listing|
      Listing.find_or_create_by(sysid: listing[:ids][:sysid].to_i) do |l|
        l.listing_id = listing[:ids][:ListingID].to_i
        l.property_type = listing[:ids][:PropertyTypeStandardName]
        l.property_tax = listing[:ids][:PropertyTax]
        l.price = listing[:price][:ListPrice].to_i
        l.original_list_price = listing[:price][:OriginalListPrice].to_i
        l.living_area = listing[:area][:LivingArea].to_i
        l.beds = listing[:rooms][:Beds].to_i
        l.baths = listing[:rooms][:BathsFull].to_i
        l.garage = to_boolean(listing[:garage][:GarageYN])
        l.description = listing[:desc][:PublicRemarks]
        l.state = listing[:address][:AddressState]
        l.city = listing[:address][:AddressCity]
        l.street = listing[:address][:AddressStreetName]
        l.full_street = listing[:address][:AddressStreetAddress]
        l.source = Listing.sources[:reso]
      end
    end
  end

  def us_states
    [
        ['Alabama', 'AL'],
        ['Alaska', 'AK'],
        ['Arizona', 'AZ'],
        ['Arkansas', 'AR'],
        ['California', 'CA'],
        ['Colorado', 'CO'],
        ['Connecticut', 'CT'],
        ['Delaware', 'DE'],
        ['District of Columbia', 'DC'],
        ['Florida', 'FL'],
        ['Georgia', 'GA'],
        ['Hawaii', 'HI'],
        ['Idaho', 'ID'],
        ['Illinois', 'IL'],
        ['Indiana', 'IN'],
        ['Iowa', 'IA'],
        ['Kansas', 'KS'],
        ['Kentucky', 'KY'],
        ['Louisiana', 'LA'],
        ['Maine', 'ME'],
        ['Maryland', 'MD'],
        ['Massachusetts', 'MA'],
        ['Michigan', 'MI'],
        ['Minnesota', 'MN'],
        ['Mississippi', 'MS'],
        ['Missouri', 'MO'],
        ['Montana', 'MT'],
        ['Nebraska', 'NE'],
        ['Nevada', 'NV'],
        ['New Hampshire', 'NH'],
        ['New Jersey', 'NJ'],
        ['New Mexico', 'NM'],
        ['New York', 'NY'],
        ['North Carolina', 'NC'],
        ['North Dakota', 'ND'],
        ['Ohio', 'OH'],
        ['Oklahoma', 'OK'],
        ['Oregon', 'OR'],
        ['Pennsylvania', 'PA'],
        ['Puerto Rico', 'PR'],
        ['Rhode Island', 'RI'],
        ['South Carolina', 'SC'],
        ['South Dakota', 'SD'],
        ['Tennessee', 'TN'],
        ['Texas', 'TX'],
        ['Utah', 'UT'],
        ['Vermont', 'VT'],
        ['Virginia', 'VA'],
        ['Washington', 'WA'],
        ['West Virginia', 'WV'],
        ['Wisconsin', 'WI'],
        ['Wyoming', 'WY']
    ]
  end

  def parse_all_states
    us_states.each do |state|
      get_listings("(AddressState=#{state[1]})")
    end
  end

end