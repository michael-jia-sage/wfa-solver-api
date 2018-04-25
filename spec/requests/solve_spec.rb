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
        expect(json['error']).to be_falsy
        expect(json['real_roots'].count).to eq(2)
        expect(json['real_roots'][0]).to eq('x = -20')
        expect(json['real_roots'][1]).to eq('x = 0')
      end
    end

    context 'when the requesting for 1 element complex equation solving' do
      let(:valid_attributes) { { e1_left: '19x^3 - 73x^2 + 7x', e1_right: '10' } }
      before { post '/solve', params: valid_attributes }

      it 'returns correct results' do
        expect(json['error']).to be_falsy
        expect(json['real_roots'].count).to eq(1)
        expect(json['complex_roots'].count).to eq(2)
      end
    end

    context 'when the requesting for 2 elements easy equation solving' do
      let(:valid_attributes) { { e1_left: 'x^2 + 2xy + y^2 - 100', e2_left: 'x^2 - 2xy + y^2 - 25' } }
      before { post '/solve', params: valid_attributes }

      it 'returns correct results' do
        expect(json['error']).to be_falsy
        expect(json['real_roots'].count).to eq(4)
        expect(json['real_roots'][0]).to eq('x = -15/2,   y = -5/2')
        expect(json['real_roots'][1]).to eq('x = -5/2,   y = -15/2')
        expect(json['real_roots'][2]).to eq('x = 5/2,   y = 15/2')
        expect(json['real_roots'][3]).to eq('x = 15/2,   y = 5/2')
      end
    end

    #below spec is for real data testing purpose, feel free to play with different inputs
    context 'when the requesting for a testing equation solving' do
      let(:valid_attributes) { {"e1_left": "x^3", "e1_right": "-8", "e2_left": "   ", "e2_right": "    ", "e3_left": "     ", "e3_right": "      "} }
      before { post '/solve', params: valid_attributes }

      it 'returns correct results' do
        expect(json['error']).to be_falsy
        expect(json['real_roots'].count).to eq(1)
        expect(json['complex_roots'].count).to eq(2)
      end
    end

  end
end
