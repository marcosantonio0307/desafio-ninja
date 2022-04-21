class Booking < ApplicationRecord
  belongs_to :room

  validates :owner, :booking_day, :schedule_starting, :schedule_ending, presence: true
  validates :schedule_starting, :schedule_ending, numericality: { only_integer: true }
end
