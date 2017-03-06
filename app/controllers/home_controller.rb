class HomeController < ApplicationController
  helper_method :current_or_guest_user

  def index
    current_or_guest_user
  end
end
