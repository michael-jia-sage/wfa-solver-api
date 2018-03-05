require 'rails_helper'

RSpec.describe 'Solve API', type: :request do
  # initialize test data

  # Test suite for GET /solve
  describe 'GET /solve' do
    # make HTTP get request before each example
    before { get '/solve' }

    it 'returns healthy message to solve' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json['value']).to eq('I am the greatest equation solver.')
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for POST /solve
  describe 'POST /solve' do
    context 'when the request is invalid' do
      before { post '/solve', params: {} }

      it 'returns status code 406 -- not acceptable' do
        expect(response).to have_http_status(406)
        expect(response.body).to include('Missing equation')
      end
    end

    context 'when the requesting for 1 element easy equation solving' do
      let(:valid_attributes) { { e1_left: 'x^2 + 20x' } }
      before { post '/solve', params: valid_attributes }

      it 'returns correct results' do
        qr = json['queryresult']
        expect(qr['success']).to eq('true')
        qr_pod = qr['pod']
        expect(qr_pod.count).to be >= 4
        expect(qr_pod[0]['title']).to eq('Input')
        expect(qr_pod[0]['subpod']['plaintext']).to eq('x^2 + 20 x = 0')
        expect(qr_pod.find {|s| s['title'].include?('Alternate forms') }).not_to be_nil
        expect(qr_pod.find {|s| s['title'].include?('Solutions') }).not_to be_nil
        expect(qr_pod.find {|s| s['title'].include?('Solutions') }['subpod'].count).to eq(2)
        expect(qr_pod.find {|s| s['title'].include?('Complex solutions') }).to be_nil
      end
    end

    context 'when the requesting for 1 element complex equation solving' do
      let(:valid_attributes) { { e1_left: '19x^3 - 73x^2 + 7x', e1_right: '10' } }
      before { post '/solve', params: valid_attributes }

      it 'returns correct results' do
        qr = json['queryresult']
        expect(qr['success']).to eq('true')
        qr_pod = qr['pod']
        expect(qr_pod.count).to be >= 4
        expect(qr_pod[0]['title']).to eq('Input')
        expect(qr_pod[0]['subpod']['plaintext']).to eq('19 x^3 - 73 x^2 + 7 x = 10')
        expect(qr_pod.find {|s| s['title'].include?('Real solution') }).not_to be_nil
        expect(qr_pod.find {|s| s['title'].include?('Complex solutions') }).not_to be_nil
      end
    end

    context 'when the requesting for 2 elements easy equation solving' do
      let(:valid_attributes) { { e1_left: 'x^2 + 2xy + y^2 - 100', e2_left: 'x^2 - 2xy + y^2 - 25' } }
      before { post '/solve', params: valid_attributes }

      it 'returns correct results' do
        qr = json['queryresult']
        expect(qr['success']).to eq('true')
        qr_pod = qr['pod']
        expect(qr_pod.count).to be >= 4
        expect(qr_pod[0]['title']).to eq('Input')
        expect(qr_pod[0]['subpod']['plaintext']).to eq('{x^2 + 2 x y + y^2 - 100 = 0, x^2 - 2 x y + y^2 - 25 = 0}')
        expect(qr_pod.find {|s| s['title'].include?('Alternate forms') }).not_to be_nil
        expect(qr_pod.find {|s| s['title'].include?('Solutions') }).not_to be_nil
        expect(qr_pod.find {|s| s['title'].include?('Solutions') }['subpod'].count).to eq(4)
        expect(qr_pod.find {|s| s['title'].include?('Complex solutions') }).to be_nil
      end
    end

  end
end
