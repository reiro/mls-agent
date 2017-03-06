require 'rets'

#login_url = 'http://agdb.rets.interealty.com/Login.asmx/Login'

#client = HTTPClient.new default_header: {"User-Agent" => "ACTRISIDX/1.0", "Authorization" => '321654'}

#client.set_auth login_url, 'ACTRISIDX/1.0', '321654'

#client.get login_url

#cont = client.get_content 'http://localhost/secure/'

#res = client.head login_url

# Access URL: http://agdb.rets.interealty.com/Login.asmx/Login
# Access Credentials:
# Login: ACTRISBETA1
# Password: 1BetaOne
# User Agent: ACTRISIDX/1.0
# UA Password: 321654

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

def short_states
  us_states.map {|q| q.last}
end


id_attrs = %w(sysid ListingID RESOPropertyType PropertyTypeStandardName PropertyTypeDescription PropertyTax PropertySubTypeDescription)

price_attrs = %w(ListPrice ListPricePrevious OriginalListPrice)

area_attrs = %w(LivingArea LotSizeAreaAcres LotSizeAreaSqFeet
  RoomsBasementArea)

rooms_attrs = %w(RoomsTotalRooms TotalUnits ParkingTotal Beds BathsFull BathsHalf)

garage_attrs = %w(GarageSpaces GarageAttachedYN GarageYN)

building_attrs = %w(Floors Roof Construction Material)

desc_attrs = %w(PublicRemarks LotDesc ListingAreaDescription ViewDescription)

address_attrs = %w(AddressState AddressCounty AddressCountry MapCoordinate
  AddressCity AddressStreetAddress AddressStreetName)

other_attrs = %w(PoolPresent CoolingPresent Cooling Fencing)

schools_attrs = %w(SchoolElementarySchool SchoolHighSchool SchoolJrHigh
  SchoolMiddleSchool SchoolSchoolDistrict SchoolElementaryDistrict)

ALL = {
        ids: id_attrs, price: price_attrs, area: area_attrs, rooms: rooms_attrs,
        garage: garage_attrs, building: building_attrs, desc: desc_attrs, 
        address: address_attrs, school: schools_attrs, other: other_attrs
      }

def parse_attrs_group(listing, attrs_set)
  attrs_set.each_with_object({}) { |a, res| res[a] = listing[a] }
end

def parse_listing(listing)
  ALL.each_with_object({}) do |a, res|
    res[a[0]] = parse_attrs_group(listing, a[1])
  end  
end




# Get one property
# Pass :first or :all
# Then :search_type (Property, Agent, ...), :class (Condo, Commerical, ...), :query and :limit

# '(ListPrice=100000-125000)AND(AddressState=TX)AND(GarageYN=Y)AND(AddressState=Austin)'
#query = '(ListPrice=100000-125000)AND(AddressState=TX)AND(GarageYN=Y)AND(Beds=3)'
#query = '(ListPrice=100000+)'
#(AddressCity=*)


#w = []
#short_states. each do |s|
#  query = "(AddressState=#{s})"
#  begin
#    listings = rets_client.find :all, {search_type: 'Property',class: 'property',standard_names: 'DataDictionary:1.4',query: query,limit: 500}
#    w << [listings.count, s]
#  rescue
#    w << [0, s] 
#  end  
#end



# [[0, "AL"], [0, "AK"], [3, "AZ"], [0, "AR"], [8, "CA"], [13, "CO"], [2, "CT"], [0, "DE"],
# [0, "DC"], [20, "FL"], [1, "GA"], [1, "HI"], [2, "ID"], [8, "IL"], [2, "IN"], [1, "IA"],
# [0, "KS"], [0, "KY"], [2, "LA"], [0, "ME"], [0, "MD"], [0, "MA"], [7, "MI"], [0, "MN"],
# [2, "MS"], [14, "MO"], [1, "MT"], [1, "NE"], [3, "NV"], [0, "NH"], [2, "NJ"], [5, "NM"],
# [6, "NY"], [3, "NC"], [0, "ND"], [6, "OH"], [0, "OK"], [0, "OR"], [1, "PA"], [0, "PR"],
# [0, "RI"], [1, "SC"], [0, "SD"], [7, "TN"], [500, "TX"], [0, "UT"], [3, "VT"], [1, "VA"],
# [1, "WA"], [2, "WV"], [0, "WI"], [0, "WY"]]







cities = %w(Houston)



query = "(AddressCity=Dallas)"

metadata_cache = Rets::Metadata::FileCache.new("/tmp/metadata")

rets_client = Rets::Client.new({
  login_url: 'http://agdb.rets.interealty.com/Login.asmx/Login',
  username: 'ACTRISBETA1',
  password: '1BetaOne',
  version: 'RETS/1.0.2',
  agent: 'ACTRISIDX/1.0',
  ua_password: '321654',
  metadata_cache: metadata_cache
})
  rets_client.login

begin
  rets_client.login
rescue => e
  puts 'Error: ' + e.message
  exit!
end

listings = rets_client.find :all, {
  search_type: 'Property',
  class: 'property',
  standard_names: 'DataDictionary:1.4',
  query: '(ListPrice=1+)',
  limit: 500
}


#2.3.0 :062 > listings.last["sysid"]
# => "143660129" 
#2.3.0 :063 > listings.first["sysid"]
 #=> "143659650" 


w = []
listings.each_with_index do |listing, i|
  p i
  parsed_listing = parse_listing(listing)
  rooms = parsed_listing[:rooms]
  w << parsed_listing[:ids]["ListingID"] unless rooms["TotalUnits"].empty?
end


# BAD PARAMS
# RoomsTotalRooms
res = parse_listing(listings.last)

# property.last.keys.each {|q| p q if q.include?("Price") }

# q = property.group_by {|p| p["AddressCity"]}
# q.map {|w| [w.first, w.last.count]}



puts 'received property: '
puts property.inspect

# puts 'We connected! Lets log out...'
# rets_client.logout