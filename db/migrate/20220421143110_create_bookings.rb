class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.references :room, null: false, foreign_key: true
      t.string :owner
      t.date :booking_day
      t.integer :schedule_starting
      t.integer :schedule_ending

      t.timestamps
    end
  end
end
