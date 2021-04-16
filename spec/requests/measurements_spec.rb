require 'rails_helper'

RSpec.describe 'Measurements API' do
  # Initialize the test data
  let!(:habit) { create(:habit) }
  let!(:measurements) { create_list(:measurement, 20, habit_id: habit.id) }
  let(:habit_id) { habit.id }
  let(:id) { measurements.first.id }

  # Test suite for GET /habits/:habit_id/measurements
  describe 'GET /habits/:habit_id/measurements' do
    before { get "/habits/#{habit_id}/measurements" }

    context 'when habit exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all habit measurements' do
        expect(json.size).to eq(20)
      end
    end

    context 'when habit does not exist' do
      let(:habit_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Habit with 'id'=0/)
      end
    end
  end

  # Test suite for GET /habits/:habit_id/measurements/:id
  describe 'GET /habits/:habit_id/measurements/:id' do
    before { get "/habits/#{habit_id}/measurements/#{id}" }

    context 'when habit measurement exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the measurement' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when habit measurement does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Measurement/)
      end
    end
  end

  # Test suite for PUT /habits/:habit_id/measurements
  describe 'POST /habits/:habit_id/measurements' do
    let(:valid_attributes) { { value: 2, date: Date.today } }

    context 'when request attributes are valid' do
      before { post "/habits/#{habit_id}/measurements", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/habits/#{habit_id}/measurements", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Value can't be blank/)
      end
    end
  end

  # Test suite for PUT /habits/:habit_id/measurements/:id
  describe 'PUT /habits/:habit_id/measurements/:id' do
    let(:valid_attributes) { { value: 3.5 } }

    before { put "/habits/#{habit_id}/measurements/#{id}", params: valid_attributes }

    context 'when measurement exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the measurement' do
        updated_measurement = Measurement.find(id)
        expect(updated_measurement.value).to match(3.5)
      end
    end

    context 'when the measurement does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Measurement/)
      end
    end
  end

  # Test suite for DELETE /habits/:id
  describe 'DELETE /habits/:id' do
    before { delete "/habits/#{habit_id}/measurements/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end