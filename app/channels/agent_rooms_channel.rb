class AgentRoomsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "agent_rooms_#{params['agent_room_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    agent = AgentRoom.find(data['agent_room_id']).agent
    current_user.messages.create!(body: data['message'], agent_room_id: data['agent_room_id'],
                                  sender_id: current_user.id, recipient_id: agent.id)
    agent.perform(data['message'])
  end
end