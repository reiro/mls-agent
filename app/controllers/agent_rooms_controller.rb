class AgentRoomsController < ApplicationController
  def index
    @agent_rooms = AgentRoom.all
  end

  def new
    @agent_room = AgentRoom.new
  end

  def show
    @agent_room = AgentRoom.includes(:messages).find_by(id: params[:id])
    @message = Message.new
  end

  def create
    @agent_room = current_user.agent_rooms.build(agent_room_params)
    if @agent_room.save
      flash[:success] = 'Agent room added!'
      redirect_to agent_rooms_path
    else
      render 'new'
    end
  end

  private

  def agent_room_params
    params.require(:agent_room).permit(:title)
  end
end