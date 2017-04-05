require 'open-uri'

class Scrapper
  URL = 'http://www.realtor.com'
  doc = Nokogiri::HTML(open(URL + "/realestateandhomes-search/Philadelphia_PA/beds-2/baths-3/price-90000-300000"))
  doc.css('.srp-list-marginless .srp-item .aspect-content').each do |listing|
    href = listing.at('.srp-item-photo a')['href']
    img = listing.at('.srp-item-photo img')['src']
    price = listing.at('.srp-item-body .srp-item-price span').text
    region = listing.at('.srp-item-address .listing-region').text
    city = listing.at('.srp-item-address .listing-city').text
    street = listing.at('.srp-item-address .listing-street-address').text
    stats = listing.at('.srp-item-property-meta')
    beds = stats.at('.property-meta-beds span').text
    baths = stats.at('.property-meta-baths span').text
    sqft = stats.at('.property-meta-sqft').text
  end
end