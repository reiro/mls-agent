require 'open-uri'

class Scrapper
  attr_accessor :listing_ids
  URL = 'http://www.realtor.com'

  def initialize
    @listing_ids = []
  end

  def parse(query={beds: 2, baths: 3, min_price: 400000, max_price: 900000})
    search_url =  '/realestateandhomes-search/'
    query_url = URL + search_url + 'Philadelphia_PA/' + "beds-#{query[:beds]}"
                + "price-#{query[:min_price]}-#{query[:max_price]}"
    doc = Nokogiri::HTML(open(query_url))

    doc.css('.srp-list-marginless .srp-item .aspect-content').each_with_index do |listing, i|
      hash = {}
      hash[:url] = listing.at('.srp-item-photo a')['href']
      hash[:photo] = listing.at('.srp-item-photo img')['src']
      hash[:price] = listing.at('.srp-item-body .srp-item-price span').try(:text)
      hash[:state] = listing.at('.srp-item-address .listing-region').try(:text)
      hash[:city] = listing.at('.srp-item-address .listing-city').try(:text)
      hash[:street] = listing.at('.srp-item-address .listing-street-address').try(:text)
      stats = listing.at('.srp-item-property-meta')
      hash[:beds] = stats.at('li[data-label="property-meta-beds"] span').try(:text)
      hash[:baths] = stats.at('li[data-label="property-meta-baths"] span').try(:text)
      hash[:living_area] = stats.at('li[data-label="property-meta-sqft"] span').try(:text)

      l = Listing.find_by(url: hash[:url])
      unless l.present?
        l = Listing.create(hash)
        full_parse(l) if l.url
      end

      @listing_ids << l.id
    end
  end

  def full_parse(listing)
    doc = Nokogiri::HTML(open(URL + listing.url))
    hash = {}

    hash[:description] = doc.at('#ldp-detail-romance').try(:text)
    hash[:"property_type"] =  doc.at('li[data-label="property-type"]').try(:text)

    listing.update(hash)
  end
end