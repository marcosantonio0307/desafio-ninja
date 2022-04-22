class Api::V1::BookingsController < ApplicationController
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
end
