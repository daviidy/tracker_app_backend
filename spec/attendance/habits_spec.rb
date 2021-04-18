# spec/requests/habits_spec.rb
require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'json'

resource "Habits" do
  explanation "Habits resource"
  header "Content-Type", "application/json"
  header "Host", "test.org"

  get "/habits" do
    let!(:habits) { create_list(:habit, 10) }
    context '200' do
      example_request 'Get a list of habits' do
        expect(status).to eq(200)
        expect(response_body).not_to be_empty
      end
    end
  end

  get "/habits/:id" do

    context '200' do
      let!(:habits) { create_list(:habit, 10) }
      let(:id) { habits.first.id }

      example 'Get a habit' do
        do_request
        json = {
          "id": habits.first.id,
          "name": habits.first.name,
          "created_at": habits.first.created_at,
          "updated_at": habits.first.updated_at
        }
        expected_response = json.to_json
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response)
      end
    end
  end

  post "/habits" do

    parameter :name, with_example: true

    let(:name) { 'Any habit' }
    let(:raw_post) { params.to_json }

    context '200' do

      example_request 'Add a habit' do

        expect(status).to eq(201)
        expect(response_body[name]).to eq('Any habit')
      end
    end
  end

  put "/habits/:id" do

    parameter :name, with_example: true

    let(:name) { 'New habit' }
    let(:raw_post) { params.to_json }

    context '200' do
      let!(:habits) { create_list(:habit, 10) }
      let(:id) { habits.first.id }
      example_request 'Edit a habit' do

        expect(status).to eq(204)
        expect(response_body).to be_empty
      end
    end
  end

  delete "/habits/:id" do

    context '200' do
      let!(:habits) { create_list(:habit, 10) }
      let(:id) { habits.first.id }
      example_request 'Delete a habit' do

        expect(status).to eq(204)
      end
    end
  end
end
