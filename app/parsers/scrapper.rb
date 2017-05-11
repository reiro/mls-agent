require 'open-uri'

class Scrapper
  attr_accessor :listing_ids
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
  URL = 'http://www.realtor.com'

  def initialize
    @listing_ids = []
  end

  def fetch_state
    return State.find_by_city('Miami') unless @address['state_name']

    states = State.where('state_short = :s or state_full = :s', s: @address['state_name'])
    if @address['place_name']
      states = states.where(city: @address['place_name'])
    end

    states.take
  end

  def full_address
    if @state
      address_string(@state.state_short, @state.city)
    elsif @address['place_name']
      address_string(@address['state_name'], @address['place_name'])
    else
      false
    end
  end

  def address_string(state, city)
    city.titleize.gsub(' ', '-') + '_' + state
  end

  def price_to_number(price)
    price
  end

  def parse_page(doc)
    doc.css('.srp-list-marginless .srp-item .aspect-content').each_with_index do |listing, i|
      hash = {}
      hash[:url] = listing.at('.srp-item-photo a')['href']
      hash[:remote_image_url] = listing.at('.srp-item-photo img')['data-src']
      hash[:price] = listing.at('.srp-item-body .srp-item-price span').try(:text)&.delete('$,')
      hash[:state] = listing.at('.srp-item-address .listing-region').try(:text)
      hash[:city] = listing.at('.srp-item-address .listing-city').try(:text)
      hash[:street] = listing.at('.srp-item-address .listing-street-address').try(:text)
      stats = listing.at('.srp-item-property-meta')
      hash[:beds] = stats.at('li[data-label="property-meta-beds"] span').try(:text)
      hash[:baths] = stats.at('li[data-label="property-meta-baths"] span').try(:text)
      hash[:living_area] = stats.at('li[data-label="property-meta-sqft"] span').try(:text)&.delete(',')

      l = Listing.find_by(url: hash[:url])
      unless l.present?
        l = Listing.create(hash)
      end
      sleep 0.5
      p @listing_ids.count
      @listing_ids << l.id
    end
  end

  def parse(query={address: {'state_name' => 'FL'}})
    @address = query[:address]
    @state = fetch_state
    return unless address = full_address

    search_url = '/realestateandhomes-search/'
    query_url = URL + search_url
    query_url += "#{address}"

    query_url += "/beds-#{query[:beds]}" if query[:beds]
    query_url += "/baths-#{query[:baths]}" if query[:baths]
    query_url += "/price-#{query[:min_price] || 'na'}-#{query[:max_price] || 'na'}" if query[:min_price] || query[:max_price]
    # query_url += "/type-single-family-home"
    # query_url += '/with_garage2ormore'
    doc = Nokogiri::HTML(open(query_url))

    parse_page(doc)
    # ListingsParseJob.perform_later(@listing_ids)
  end

  def parse_state(state)
    search_url = '/realestateandhomes-search/'
    query_url = URL + search_url
    top_cities_url = URL + '/local/' + state.state_full.gsub(' ', '-')

    top_cities_doc = Nokogiri::HTML(open(top_cities_url))
    top_cities_doc.at('#top-cities table td.col-area a').each do |city|
      city_url = query_url + address_string(state.state_short, city[1])
      city_filters_url = city_url + '/beds-1/baths-1/type-single-family-home,condo-townhome-row-home-co-op/price-100000-800000'

      doc = Nokogiri::HTML(open(city_filters_url))
      per_page = doc.css('#srp-select-count option').last['value']
      per_page_url = "?pgsz=#{per_page}"

      doc_per_page = Nokogiri::HTML(open(city_filters_url + per_page_url))


      if doc_per_page.css('nav.pagination span.page a').empty?
        parse_page(doc_per_page)
      else
        total_pages = doc_per_page.css('nav.pagination span.page a').last.text.to_i
        (1..total_pages).each do |i|
          query = city_filters_url + "/pg-#{i}" + per_page_url
          doc = Nokogiri::HTML(open(query))
          parse_page(doc)
        end
      end
    end
  end

  def self.full_parse
    listings = Listing.realtor.where(year_built: nil)

    listings.each do |listing|
      doc = Nokogiri::HTML(open(URL + listing.url))
      hash = {}

      hash[:description] = doc.at('#ldp-detail-romance').try(:text)
      hash[:"property_type"] =  doc.at('li[data-label="property-type"] .ellipsis').try(:text)
      hash[:year_built] = doc.at('li[data-label="property-year"] .ellipsis').try(:text)

      schools = []
      doc.css('table.school-rating-lg tbody tr').each do |school|
        score = school.css('span.school-rating').try(:text)
        name = school.css('td')[1].try(:text)&.strip
        distance = school.css('td')[3].try(:text)&.gsub(' mi', '')
        schools << [score, name, distance]
      end
      schools.sort_by! { |s| s[0] }
      hash[:schools_count] = schools.count
      if schools.count > 0
        hash[:top_school_rating] = schools.first[0]
        hash[:top_school_name] = schools.first[1]
        hash[:top_school_distance] = schools.first[2]
      end

      listing.update(hash)
    end
  end
end
