class Booking < ApplicationRecord
  belongs_to :room

  validates :owner, :booking_day, :schedule_starting, :schedule_ending, presence: true
  validates :schedule_starting, :schedule_ending, numericality: { only_integer: true }
  validates :booking_day, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }

  validates_each :booking_day do |record, attr, _value|
    if record.booking_day && record.invalid_day?
      record.errors.add(attr,
                        I18n.t('activerecord.errors.messages.day_is_weekend'))
    end
  end

  validates_each :schedule_starting, :schedule_ending do |record, attr, value|
    if record.room && record.schedule_starting && record.schedule_ending
      record.errors.add(attr, I18n.t('activerecord.errors.messages.unpermitted_time')) if invalid_time?(value)
      if record.time_already_booked?(value)
        record.errors.add(attr,
                          I18n.t('activerecord.errors.messages.time_already_booked'))
      end
    end
  end

  def invalid_day?
    booking_day.saturday? || booking_day.sunday?
  end

  def self.invalid_time?(schedule_time)
    return true if schedule_time < ENV['ROOM_OPENING_TIME'].to_i ||
                   schedule_time > ENV['ROOM_CLOSING_TIME'].to_i

    false
  end

  def time_already_booked?(schedule_time)
    registered_bookings = if id.nil?
                            room.bookings.where(booking_day: booking_day)
                          else
                            room.bookings.where(['booking_day = ? and id != ?', booking_day, id])
                          end

    registered_bookings.each do |register|
      return true if schedule_time.between?(register.schedule_starting, register.schedule_ending)
    end

    false
  end
end
