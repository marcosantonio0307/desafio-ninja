require 'rails_helper'

RSpec.describe Api::V1::BookingsController, type: :controller do
  describe 'POST create' do
    before(:each) do
      Room.create(name: 'teste')
    end

    context 'com parâmetros válidos' do
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

    context 'quando é um dia não comercial' do
      let(:params) do
        {
          room_id: Room.last.id,
          owner: 'test',
          booking_day: '23/04/2022',
          schedule_starting: 1000,
          schedule_ending: 1200
        }
      end

      it 'retorna erro ao ser sábado' do
        post :create, params: params, as: :json

        data = JSON.parse(response.body)['errors']
        expect(response.status).to eq(400)
        expect(data).to include('Booking day not permitted, is weekend')
      end

      it 'retorna erro ao ser domingo' do
        params[:booking_day] = '24/04/2022'

        post :create, params: params, as: :json

        data = JSON.parse(response.body)['errors']
        expect(response.status).to eq(400)
        expect(data).to include('Booking day not permitted, is weekend')
      end
    end

    context 'quando é um horário inválido' do
      let(:params) do
        {
          room_id: Room.last.id,
          owner: 'test',
          booking_day: '22/04/2022',
          schedule_starting: 700,
          schedule_ending: 1000
        }
      end

      it 'retorna erro' do
        post :create, params: params, as: :json

        data = JSON.parse(response.body)['errors']
        expect(response.status).to eq(400)
        expect(data).to include('Schedule starting unpermitted time')
      end
    end

    context 'quando é um horário já agendado' do
      before(:each) do
        Booking.create!(
          room_id: Room.last.id,
          owner: 'test',
          booking_day: '22/04/2022',
          schedule_starting: 1000,
          schedule_ending: 1200
        )
      end

      let(:params) do
        {
          room_id: Room.last.id,
          owner: 'test',
          booking_day: '22/04/2022',
          schedule_starting: 1100,
          schedule_ending: 1300
        }
      end

      it 'retorna erro' do
        post :create, params: params, as: :json

        data = JSON.parse(response.body)['errors']
        expect(response.status).to eq(400)
        expect(data).to include('Schedule starting time already booked')
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
