# spec/requests/habits_spec.rb
require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.describe 'Habits API', type: :request do
  # initialize test data
  let!(:user) { create(:user) }
  let!(:habits) { create_list(:habit, 10) }
  let(:habit_id) { habits.first.id }

  let(:auth_params) { { email: user.email, password: user.password } }

  def authenticated_header(user)
    post '/auth', params: { email: user.email, password: user.password }
    token = json['token']
    { 'Authorization': "Bearer #{token}" }
  end

  # Test suite for GET /habits
  describe 'GET /habits' do
    # make HTTP get request before each example
    before { get '/habits', headers: authenticated_header(user) }

    it 'returns habits' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /habits/:id
  describe 'GET /habits/:id' do
    before { get "/habits/#{habit_id}", headers: authenticated_header(user) }

    context 'when the record exists' do
      it 'returns the habit' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(habit_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:habit_id) { 200 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Habit with 'id'=200/)
      end
    end
  end

  # Test suite for POST /habits
  describe 'POST /habits' do
    # valid payload
    let(:valid_attributes) { { name: 'Learn Elm' } }

    context 'when the request is valid' do
      before { post '/habits', params: valid_attributes, headers: authenticated_header(user) }

      it 'creates a habit' do
        expect(json['name']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/habits', params: { title: 'Foobar' }, headers: authenticated_header(user) }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /habits/:id
  describe 'PUT /habits/:id' do
    let(:valid_attributes) { { name: 'Shopping' } }

    context 'when the record exists' do
      before { put "/habits/#{habit_id}", params: valid_attributes, headers: authenticated_header(user) }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /habits/:id
  describe 'DELETE /habits/:id' do
    before { delete "/habits/#{habit_id}", headers: authenticated_header(user) }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
