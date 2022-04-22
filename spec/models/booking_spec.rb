require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe '.create' do
    let(:room) { Room.create(name: 'Sala Exemplo') }
    context 'retorna sucesso' do
      it 'quando os parâmetros são informados' do
        booking = Booking.new(room_id: room.id, owner: 'Marcos', booking_day: '22/04/2022',
                              schedule_starting: 1000, schedule_ending: 1200)

        expect { booking.save! }.to change { Booking.count }.by(1)
      end
    end

    context 'retorna erro' do
      it 'quando não existe a Room' do
        expect(Booking.create.errors.full_messages).to include('Room must exist')
      end

      it 'quando existe a Room, mas os parâmetros são inválidos' do
        booking = Booking.new(room_id: room.id)

        expect { booking.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'quando os horários são de tipo incorreto' do
        booking = Booking.new(room_id: room.id, owner: 'Marcos', booking_day: '22/04/2022',
                              schedule_starting: '10:00', schedule_ending: '12:00')

        expect { booking.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'quando o formato da data é errado' do
        booking = Booking.new(room_id: room.id, owner: 'Marcos', booking_day: '03042022',
                              schedule_starting: 1000, schedule_ending: 1200)

        expect { booking.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
