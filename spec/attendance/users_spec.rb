# spec/requests/habits_spec.rb
# rubocop:disable  Metrics/BlockLength
require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'json'

resource 'Users' do
  explanation 'How to sign up and sign in'
  header 'Content-Type', 'application/json'
  header 'Host', 'test.org'

  token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImV4cCI6MTYyMDM4MDk5NX0.9kdtRxlazvcIK5RdwhfgeBb0rPhPuA1H3jpRNcZOBo0'

  header 'Authorization', "Bearer #{token}"

  post '/users' do
    parameter :username, with_example: true
    parameter :email, with_example: true
    parameter :password, with_example: true

    context '201' do
      let!(:username) { 'dave' }
      let!(:email) { 'test@test.com' }
      let!(:password) { 'dave123' }

      let(:raw_post) { params.to_json }
      example_request 'Create a new user' do
        explanation 'You should add the following parameters to create a new user'
        fake = JSON.parse(response_body)
        expect(status).to eq(200)
        expect(fake['email']).to eq(email)
      end
    end
  end

  post '/auth' do
    parameter :email, with_example: true
    parameter :password, with_example: true

    context '201' do
      let!(:user) { create(:user) }

      let!(:email) { user.email }
      let!(:password) { user.password }

      let(:raw_post) { params.to_json }
      example_request 'Sign in the user and get token' do
        fake = JSON.parse(response_body)
        expect(status).to eq(200)
        expect(fake['token']).not_to be_empty
      end
    end
  end
end
# rubocop:enable  Metrics/BlockLength
