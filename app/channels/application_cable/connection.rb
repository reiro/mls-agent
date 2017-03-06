module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :current_agent

    def connect
      self.current_user = find_verified_user
      self.current_agent = current_agent
      logger.add_tags 'ActionCable', current_user.email
    end

    # def agent
    #   @ability ||= Ability.new(current_user)
    # end

    protected

    def find_verified_user # this checks whether a user is authenticated with devise
      if verified_user = env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def current_agent
      @agent ||= Agent.new
    end

  end
end