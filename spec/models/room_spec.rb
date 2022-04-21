require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '.create' do
    it 'cria uma Room com sucesso' do
      room = Room.new(name: 'Sala Exemplo')  

      expect{room.save!}.to change {Room.count}.by(1)
    end

    it 'retorna erro ao criar sem um nome' do
      room = Room.new(name: '')
      
      expect{room.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
