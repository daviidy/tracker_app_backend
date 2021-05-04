# spec/attendance/habits_spec.rb
# rubocop:disable  Metrics/BlockLength
require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'json'

resource 'Measurements' do
  explanation 'Measurements resource'
  header 'Content-Type', 'application/json'
  header 'Host', 'test.org'

  token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImV4cCI6MTYyMDM4MDk5NX0.9kdtRxlazvcIK5RdwhfgeBb0rPhPuA1H3jpRNcZOBo0'

  header 'Authorization', "Bearer #{token}"

  get '/habits/:habit_id/measurements' do
    let!(:habit) { create(:habit) }
    let!(:user) { create(:user) }
    let!(:measurements) { create_list(:measurement, 20, habit_id: habit.id, user_id: user.id) }
    let(:habit_id) { habit.id }
    context '200' do
      example 'Get a list of measurements for a habit' do
        user.id = 1
        user.save
        do_request
        expect(status).to eq(200)
        expect(response_body).not_to be_empty
      end
    end
  end

  get '/habits/:habit_id/measurements/:id' do
    context '200' do
      let!(:habit) { create(:habit) }
      let!(:user) { create(:user) }
      let!(:measurements) { create_list(:measurement, 20, habit_id: habit.id, user_id: user.id) }
      let(:habit_id) { habit.id }
      let(:id) { measurements.first.id }

      example 'Get a measurement' do
        user.id = 1
        user.save
        do_request
        json = {
          "id": measurements.first.id,
          "value": measurements.first.value,
          "date": measurements.first.date,
          "habit_id": measurements.first.habit_id,
          "created_at": measurements.first.created_at,
          "updated_at": measurements.first.updated_at,
          "user_id": measurements.first.user_id
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
    parameter :user_id, with_example: true

    let!(:user) { create(:user) }

    let(:value) { 10.2 }
    let(:date) { Date.today }
    let!(:user_id) { 1 }

    let(:raw_post) { params.to_json }

    let!(:habit) { create(:habit) }
    let(:habit_id) { habit.id }

    context '201' do
      example 'Add a measurement' do
        user.id = 1
        user.save
        do_request
        expect(status).to eq(201)
      end
    end
  end

  put '/habits/:habit_id/measurements/:id' do
    parameter :value, with_example: true

    let!(:user) { create(:user) }

    let(:value) { 13 }
    let(:raw_post) { params.to_json }

    context '204' do
      let!(:habit) { create(:habit) }
      let!(:measurements) { create_list(:measurement, 20, habit_id: habit.id, user_id: user.id) }
      let(:habit_id) { habit.id }
      let(:id) { measurements.first.id }
      example 'Edit a measurement' do
        user.id = 1
        user.save
        do_request
        expect(status).to eq(204)
        expect(response_body).to be_empty
      end
    end
  end

  delete '/habits/:habit_id/measurements/:id' do
    context '204' do
      let!(:habit) { create(:habit) }
      let!(:user) { create(:user) }
      let!(:measurements) { create_list(:measurement, 20, habit_id: habit.id, user_id: user.id) }
      let(:habit_id) { habit.id }
      let(:id) { measurements.first.id }
      example 'Delete a measurement' do
        user.id = 1
        user.save
        do_request
        expect(status).to eq(204)
      end
    end
  end
end
# rubocop:enable  Metrics/BlockLength
