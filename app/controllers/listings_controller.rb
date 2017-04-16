class ListingsController < ApplicationController
  def index
    @listings = Listing.all
  end

  def show
    @listing = Listing.includes(:messages).find_by(id: params[:id])
    @message = Message.new
  end
end