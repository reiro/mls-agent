class Agent
  attr_accessor :name, :init_message, :income, :outcome, :greetings, :type,
                :price, :beds, :baths, :car, :state, :city, :family, :childrens

  def initialize(name = 'Agent Smith', init_message = '')
    @name = name
    @init_message = init_message
    @income = []
    @outcome = []
    @greetings = false
    @type = false
    @price = false
    @beds = false
    @baths = false
    @car = false
    @state = false
    @city = false
    @family = false
    @childrens = false
  end

  def perform(message, agent_id, user_id)
    url = 'http://localhost:8000'
    headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    params = { 'message': message, agent: self.as_json }.to_json
    response = HTTParty.post(url, body: params, headers: headers)
    response = JSON.parse(response.body)
    Message.create!(body: response['message'], agent_room_id: agent_id, user_id: user_id)
  end
end