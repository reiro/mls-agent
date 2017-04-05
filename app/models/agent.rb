class Agent < ApplicationRecord
  belongs_to :agent_room, optional: true
  # attr_accessor :name, :init_message, :income, :outcome, :greetings, :actions, :address,
  #               :price, :beds, :baths, :car, :state, :city, :family, :childrens

  # def initialize(name = 'Agent Smith', init_message = '')
  #   @name = name
  #   @init_message = init_message
  #   @income = []
  #   @outcome = []
  #   @greetings = false
  #   @actions = false
  #   @beds = false
  #   @baths = false
  #   @price = false
  #   @address = false
  #   @car = false
  #   @state = false
  #   @city = false
  #   @family = false
  #   @childrens = false
  # end

  def perform(message)
    url = 'http://localhost:8000'
    headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    params = { 'message': message, agent: self.as_json }.to_json
    response = HTTParty.post(url, body: params, headers: headers)
    response = JSON.parse(response.body)

    agent_room = self.agent_room
    user = agent_room.user
    Message.create(body: response['message'], agent_room_id: agent_room.id, user_id: user.id,
                    sender_id: self.id, recipient_id: user.id)
    if response['question']
      Message.create(body: response['question'], agent_room_id: agent_room.id, user_id: user.id)
    end

    self.assign_attributes(response['agent'])
    self.save
  end
end