class Agent < ApplicationRecord
  belongs_to :agent_room, optional: true

  def self.fields_boolean
    Agent.column_names.select { |q| q.include?('has_') }
  end

  def self.fields
    Agent.column_names.select { |q| !q.include?('has_') } - ['id', 'name', 'address', 'data', 'agent_room_id']
  end

  def clear
    fields = Agent.fields_boolean.each_with_object({}) { |f, obj| obj[f] = false }
    fields = Agent.fields.each_with_object(fields) { |f, obj| obj[f] = nil }
    fields[:address] = {}
    fields[:data] = {}
    update(fields)
    agent_room.messages.delete_all
  end

  def ready?
    ready = true
    required_fields = Agent.fields_boolean - ['has_min_price']
    required_fields.each { |f| ready = false unless self[f] }
    ready
  end

  def scrape_listings
    scrapper = Scrapper.new
    scrapper.parse({beds: beds, baths: baths, min_price: min_price, max_price: max_price, state: address['state_name']})
    scrapper.listing_ids
  end

  def perform(message)
    url = 'http://localhost:8000'
    headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    params = { 'message': message, agent: self.as_json }.to_json
    response = HTTParty.post(url, body: params, headers: headers)
    response = JSON.parse(response.body)

    agent_room = self.agent_room
    user = agent_room.user
    message_params = { agent_room_id: agent_room.id,
                       user_id: user.id,
                       agent_id: self.id,
                       sender_type: Message.sender_types[:agent]
                      }

    Message.create(message_params.merge(body: response['message']))
    Message.create(message_params.merge(body: response['question']))

    self.assign_attributes(response['agent'])
    self.save

    if ready?
      listings_ids = scrape_listings
      listings = Listing.where(id: listings_ids).limit(3)
      listings_partial = ListingsController.render :index, assigns: { listings: listings }, layout: false

      Message.create(message_params.merge(body: listings_partial))
    end
  end
end