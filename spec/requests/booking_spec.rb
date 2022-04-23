require 'rails_helper'

RSpec.describe 'Booking Request', type: :request do
  context 'sem usuário criado' do
    it 'retorna unauthorized' do
      get '/api/v1/bookings', as: :json

      expect(response.status).to eq(401)
    end
  end

  context 'cria usuário, autentica e faz requisição' do
    let(:params) do
      {
        email: 'test123@test.com',
        password: '123456'
      }
    end

    it 'retorna sucesso' do
      post '/api/auth', params: params, as: :json
      post '/api/auth/sign_in', params: params, as: :json

      headers = {
        'access-token': response.headers['access-token'],
        'client': response.headers['client'],
        'uid': response.headers['uid'],
        'expiry': response.headers['expiry']
      }

      get '/api/v1/bookings', headers: headers, as: :json

      expect(response.status).to eq(200)
    end
  end
end
