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
    result = `python bot_1.py "#{message}"`
    puts result
    Message.create!(body: result, agent_room_id: agent_id, user_id: user_id)
  end
end