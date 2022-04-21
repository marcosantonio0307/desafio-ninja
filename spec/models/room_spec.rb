require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '.create' do
    context 'retorna sucesso' do
      it 'quando o parâmetro é informado' do
        room = Room.new(name: 'Sala Exemplo')

        expect { room.save! }.to change { Room.count }.by(1)
      end
    end
    context 'retorna erro' do
      it 'quando o parâmetro não é informado' do
        room = Room.new(name: '')

        expect { room.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
