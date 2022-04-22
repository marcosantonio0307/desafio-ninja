class Api::V1::BookingsController < ApplicationController
  def index
    find_bookings(params)

    render json: { bookings_count: @bookings.count, bookings: @bookings }
  end

  def create
    booking = Booking.new values

    if booking.save
      render json: { success: booking }
    else
      render json: { errors: booking.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if booking.update values
      render json: { success: booking }
    else
      render json: { errors: booking.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    if booking.destroy!
      render json: { success: I18n.t('deleted') }
    else
      render json: { errors: booking.errors.full_messages }, status: :bad_request
    end
  end

  private

  def values
    params.require(:booking).permit(
      :room_id,
      :owner,
      :booking_day,
      :schedule_starting,
      :schedule_ending
    )
  end

  def booking
    @booking ||= Booking.find(params[:id])
  end

  def find_bookings(params)
    room_id = params[:room_id]
    booking_day = params[:booking_day]

    @bookings = if room_id && booking_day
                  Booking.where(room_id: room_id, booking_day: booking_day)
                elsif room_id
                  Booking.where(room_id: room_id)
                elsif booking_day
                  Booking.where(booking_day: booking_day)
                else
                  Booking.all
                end
  end
end
