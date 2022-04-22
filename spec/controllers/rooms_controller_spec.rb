require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do
	describe 'GET index' do
		before(:each) do
			Room.create([
				{name: 'Sala 1'},
				{name: 'Sala 2'},
				{name: 'Sala 3'},
				{name: 'Sala 4'}
			])
		end

		context 'busca todas as Rooms' do
			it 'retorna sucesso' do
				get :index, as: :json

				data = JSON.parse(response.body)
				expect(response.status).to eq(200)
				expect(data['rooms_count']).to eq(4)
				expect(data['rooms'].count).to eq(4)
			end
		end
	end
end