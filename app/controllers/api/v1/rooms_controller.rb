class Api::V1::RoomsController < ApplicationController
  before_action :authenticate_api_user!

  def index
    rooms = Room.all

    render json: { rooms_count: rooms.count, rooms: rooms }
  end
end
