# spec/requests/habits_spec.rb
require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'json'

resource 'Measurements' do
  explanation 'Measurements resource'
  header 'Content-Type', 'application/json'
  header 'Host', 'test.org'

  get '/habits/:habit_id/measurements' do
    let!(:habit) { create(:habit) }
    let!(:measurements) { create_list(:measurement, 20, habit_id: habit.id) }
    let(:habit_id) { habit.id }
    context '200' do
      example_request 'Get a list of measurements for a habit' do
        expect(status).to eq(200)
        expect(response_body).not_to be_empty
      end
    end
  end

  get '/habits/:habit_id/measurements/:id' do
    context '200' do
      let!(:habit) { create(:habit) }
      let!(:measurements) { create_list(:measurement, 20, habit_id: habit.id) }
      let(:habit_id) { habit.id }
      let(:id) { measurements.first.id }

      example 'Get a measurement' do
        do_request
        json = {
          "id": measurements.first.id,
          "value": measurements.first.value,
          "date": measurements.first.date,
          "habit_id": measurements.first.habit_id,
          "created_at": measurements.first.created_at,
          "updated_at": measurements.first.updated_at
        }
        expected_response = json.to_json
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response)
      end
    end
  end

  post '/habits/:habit_id/measurements' do
    parameter :value, with_example: true
    parameter :date, with_example: true

    let(:value) { 10.2 }
    let(:date) { Date.today }

    let(:raw_post) { params.to_json }

    let!(:habit) { create(:habit) }
    let(:habit_id) { habit.id }

    context '200' do
      example_request 'Add a measurement' do
        expect(status).to eq(201)
      end
    end
  end

  put '/habits/:habit_id/measurements/:id' do
    parameter :value, with_example: true

    let(:value) { 13 }
    let(:raw_post) { params.to_json }

    context '200' do
      let!(:habit) { create(:habit) }
      let!(:measurements) { create_list(:measurement, 20, habit_id: habit.id) }
      let(:habit_id) { habit.id }
      let(:id) { measurements.first.id }
      example_request 'Edit a measurement' do
        expect(status).to eq(204)
        expect(response_body).to be_empty
      end
    end
  end

  delete '/habits/:habit_id/measurements/:id' do
    context '200' do
      let!(:habit) { create(:habit) }
      let!(:measurements) { create_list(:measurement, 20, habit_id: habit.id) }
      let(:habit_id) { habit.id }
      let(:id) { measurements.first.id }
      example_request 'Delete a measurement' do
        expect(status).to eq(204)
      end
    end
  end
end
