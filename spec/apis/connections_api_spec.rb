require 'spec_helper'
require './lib/services/users_service.rb'
require './lib/services/merchants_service.rb'

def app
  ApplicationApi
end

describe ConnectionsApi do
  include Rack::Test::Methods

  describe 'get /:id' do
    context 'with valid id' do
      it 'returns the correct user' do
        c = FactoryGirl.build(:connection)
        c.save(validate: false)
        get "/connections/#{c.id}"
        expect(parsed_response[:data].id).to eq c.id.to_s
      end
    end

    context 'with invalid id' do
      it 'returns Connection Not Found error' do
        get "/connections/0"
        expected_error = Hashie::Mash.new({ code: 'record_not_found', message: 'record not found' })
        expect(parsed_response[:error]).to eq expected_error
        expect(last_response.status).to eq 404
      end
    end
  end

  describe 'post /' do
    
    before :each do
      Services::Merchants.stub(:find).with(123123123 ).and_return({:data => {"object_type"=>"merchant", "id"=>"2", "name"=>"Bob's Burgers", "email_address"=>"bob@test.com", "hashed_screen_name"=>123123123, "ttl"=>0}})
    end

    context 'with valid attributes' do
      it 'Creates a new Connection' do
        Services::Users.stub(:find).with(123123123).and_return({:data => {"object_type"=>"user", "id"=>"2", "first_name"=>"bob","last_name"=>"jay", "email_address"=>"bob@test.com", "hashed_screen_name"=>123123123}})
        params = { user_id: 123123123, merchant_id: 123123123 }
        expect{ post "/connections", params }.to change{ Connection.count }.by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a user when missing user_id' do
        params = { merchant_id: 123123123 }
        expected_error = Hashie::Mash.new({ code: 'api_error', message: 'user_id is missing' })
        expect{ post "/connections", params }.not_to change{ Connection.count }
        expect(last_response.status).to eq 400
        expect(parsed_response[:error]).to eq expected_error
      end

      it 'does not create a user when user_id does not reference an actual user' do
        Services::Users.stub(:find).with(123123123).and_return({:error => {"code"=>"api_error","message"=>"User Not Found"}})
        params = { user_id: 123123123, merchant_id: 123123123 }
        expected_error = Hashie::Mash.new({ code: 'api_error', message: 'User does not exist' })
        expect{ post "/connections", params }.not_to change{ Connection.count }
        expect(last_response.status).to eq 400
        expect(parsed_response[:error]).to eq expected_error
      end
    end
  end

end
