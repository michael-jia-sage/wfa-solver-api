require 'rails_helper'

RSpec.describe 'Caltest API', type: :request do
  # initialize test data

  # Test suite for GET /caltest
  describe 'GET /caltest' do
    # make HTTP get request before each example
    before { get '/caltest' }

    it 'returns I am good to caltest' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json['value']).to eq('I am good')
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for POST /caltest
  describe 'POST /caltest' do
    # valid payload
    let(:valid_attributes) { { qtype: 'constant', qparams: 'pi' } }

    context 'when the request is valid' do
      before { post '/caltest', params: valid_attributes }

      it 'returns pi value' do
        expect(json['queryresult']['success']).to eq('true')
      end

      # it 'returns status code 201' do
      #   expect(response).to have_http_status(201)
      # end
    end

    context 'when the request is invalid' do
      before { post '/caltest', params: { qtype: 'bad' } }

      # it 'returns status code 422' do
      #   expect(response).to have_http_status(422)
      # end

      # it 'returns a validation failure message' do
      #   expect(response.body).to include('Validation failed')
      # end
    end
  end
end
