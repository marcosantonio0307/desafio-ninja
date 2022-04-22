class Api::V1::RoomsController < ApplicationController
	def index
		rooms = Room.all

		render json: { rooms_count: rooms.count, rooms: rooms }
	end
end