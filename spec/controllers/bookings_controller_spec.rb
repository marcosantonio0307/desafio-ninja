require 'rails_helper'

RSpec.describe Api::V1::BookingsController, type: :controller do
  describe 'POST create' do
    context 'com parâmetros válidos' do
      before(:each) do
        Room.create(name: 'teste')
      end

      let(:params) do
        {
          room_id: Room.last.id,
          owner: 'test',
          booking_day: '21/04/2022',
          schedule_starting: 1000,
          schedule_ending: 1200
        }
      end

      it 'retorna sucesso' do
        post :create, params: params, as: :json

        data = JSON.parse(response.body)['success']
        expect(response.status).to eq(200)
        expect(data['owner']).to eq(params[:owner])
      end
    end

    context 'com parâmetros inválidos' do
      let(:params) do
        {
          room_id: '',
          owner: '',
          booking_day: '',
          schedule_starting: '',
          schedule_ending: ''
        }
      end

      it 'retorna erro' do
        post :create, params: params, as: :json

        expect(response.status).to eq(400)
      end
    end
  end

  describe 'PUT update' do
    before(:each) do
      Room.create(name: 'teste')

      Booking.create(
        room_id: Room.last.id,
        owner: 'test',
        booking_day: '21/04/2022',
        schedule_starting: 1000,
        schedule_ending: 1200
      )
    end

    context 'com parâmetros válido' do
      let(:params) do
        {
          id: Booking.last,
          owner: 'Marcos',
          schedule_starting: 1200,
          schedule_ending: 1400
        }
      end

      it 'retorna sucesso' do
        put :update, params: params, as: :json

        data = JSON.parse(response.body)['success']
        expect(response.status).to eq(200)
        expect(data['owner']).to eq(params[:owner])
        expect(data['schedule_starting']).to eq(params[:schedule_starting])
        expect(data['schedule_ending']).to eq(params[:schedule_ending])
      end
    end

    context 'com parâmetros inválidos' do
      let(:params) do
        {
          id: Booking.last,
          owner: '',
          booking_day: '',
          schedule_starting: '',
          schedule_ending: ''
        }
      end

      it 'retorna erro' do
        put :update, params: params, as: :json

        data = JSON.parse(response.body)['errors']
        expect(response.status).to eq(400)
        expect(data).to include("Owner can't be blank")
        expect(data).to include("Booking day can't be blank")
        expect(data).to include("Schedule starting can't be blank")
        expect(data).to include("Schedule ending can't be blank")
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      Room.create(name: 'teste')

      Booking.create(
        room_id: Room.last.id,
        owner: 'test',
        booking_day: '21/04/2022',
        schedule_starting: 1000,
        schedule_ending: 1200
      )
    end

    context 'com parâmetros válidos' do
      it 'retorna sucesso' do
        delete :destroy, params: { id: Booking.last.id }, as: :json

        data = JSON.parse(response.body)['success']
        expect(response.status).to eq(200)
        expect(data).to eq(I18n.t('deleted'))
      end
    end

    context 'com parâmetros inválidos' do
      it 'retorna erro' do
        expect do
          delete :destroy, params: { id: 3333 }, as: :json
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
