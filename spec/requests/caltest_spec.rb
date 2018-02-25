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
    context 'when the request is invalid' do
      before { post '/caltest', params: { qtype: 'bad' } }

      it 'returns status code 406 -- not acceptable' do
        expect(response).to have_http_status(406)
        expect(response.body).to include('Query type is not acceptable')
      end
    end

    context 'when requesting for instance' do
      # valid payload
      let(:valid_attributes) { { qtype: 'constant', qparams: 'pi' } }
      before { post '/caltest', params: valid_attributes }

      it 'returns pi value' do
        qr = json['queryresult']
        expect(qr['success']).to eq('true')
        qr_pod = qr['pod']
        expect(qr_pod.count).to be >= 2
        expect(qr_pod[0]['title']).to eq('Input')
        expect(qr_pod[0]['subpod']['plaintext']).to eq('pi')
        qr_pod_decimal = qr_pod.find {|s| s['title'].include?('Decimal') }
        expect(qr_pod_decimal['subpod']['plaintext']).to start_with('3.1415926')
      end
    end

    context 'when the requesting for 1 element equation solving' do
      # valid payload
      let(:valid_attributes) { { qtype: 'equation', qparams: '19x^3 - 73x^2 + 7x - 10 = 0' } }
      before { post '/caltest', params: valid_attributes }

      it 'returns correct results' do
        qr = json['queryresult']
        expect(qr['success']).to eq('true')
        qr_pod = qr['pod']
        expect(qr_pod.count).to be >= 4
        expect(qr_pod[0]['title']).to eq('Input')
        expect(qr_pod[0]['subpod']['plaintext']).to eq('19 x^3 - (73 x^2) (7 x) - 10 = 0')
        expect(qr_pod.find {|s| s['title'].include?('Root plot') }).not_to be_nil
        expect(qr_pod.find {|s| s['title'].include?('Alternate forms') }).not_to be_nil
        expect(qr_pod.find {|s| s['title'].include?('Real solution') }).not_to be_nil
        expect(qr_pod.find {|s| s['title'].include?('Complex solutions') }).not_to be_nil
      end
    end

  end
end
