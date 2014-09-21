require 'spec_helper'

describe Connection do


  describe "fresh_connection" do
    context "with missing fields" do
      it "is false without user_id" do
        Services::Users.stub(:find).with(nil).and_return({:error => 'test'})
        Services::Merchants.stub(:find).with(1).and_return({:data => {"object_type"=>"merchant", "id"=>"2", "name"=>"Bob's Burgers", "email_address"=>"bob@test.com", "hashed_screen_name"=>5814721655289093417, "ttl"=>0}})
        connection = Connection.new(merchant_id: 1)
        expect(connection).not_to be_valid
      end

      it "is false without merchant_id" do
        Services::Merchants.stub(:find).with(nil).and_return({:error => 'test'})
        Services::Users.stub(:find).with(1).and_return({:data => {"object_type"=>"user", "id"=>"2", "first_name"=>"bob","last_name"=>"jay", "email_address"=>"bob@test.com", "hashed_screen_name"=>5814721655289093417}})
        connection = Connection.new(user_id: 1)
        expect(connection).not_to be_valid
      end

    end

    context "without previous check-ins" do
      it "is true" do
        Services::Merchants.stub(:find).with(1).and_return({:data => {"object_type"=>"merchant", "id"=>"2", "name"=>"Bob's Burgers", "email_address"=>"bob@test.com", "hashed_screen_name"=>5814721655289093417, "ttl"=>0}})
        Services::Users.stub(:find).with(1).and_return({:data => {"object_type"=>"user", "id"=>"2", "first_name"=>"bob","last_name"=>"jay", "email_address"=>"bob@test.com", "hashed_screen_name"=>5814721655289093417}})
        connection = Connection.new(merchant_id: 1, user_id: 1)
        expect(connection).to be_valid
      end
    end

    context "with previous connection" do
      let!(:connection) { c = FactoryGirl.build(:connection) 
                          c.save(validate:false)
                          c }
      before :each do
        Services::Users.stub(:find).with(1).and_return({:data => {"object_type"=>"user", "id"=>"2", "first_name"=>"bob","last_name"=>"jay", "email_address"=>"bob@test.com", "hashed_screen_name"=>5814721655289093417}})
      end

      describe "with infinite ttl" do                    
        it "is valid" do
          Services::Merchants.stub(:find).with(1).and_return({:data => {"object_type"=>"merchant", "id"=>"2", "name"=>"Bob's Burgers", "email_address"=>"bob@test.com", "hashed_screen_name"=>5814721655289093417, "ttl"=>0}})
          connection = Connection.new(merchant_id: 1, user_id: 1)
          expect(connection).to be_valid
        end
      end

      context "with defined ttl" do
        before :each do
          Services::Merchants.stub(:find).with(1).and_return({:data => {"object_type"=>"merchant", "id"=>"2", "name"=>"Bob's Burgers", "email_address"=>"bob@test.com", "hashed_screen_name"=>5814721655289093417, "ttl"=>2}})
        end

        it "is valid when new connection is after ttl" do
          fake_time = Time.new + (3600*3)
          Time.stub(:now).and_return(fake_time)
          connection = Connection.new(merchant_id: 1, user_id: 1)
          expect(connection).to be_valid
        end

        it "is invalid when new connection is in ttl span" do
          connection = Connection.new(merchant_id: 1, user_id: 1)
          expect(connection).not_to be_valid
        end
      end
    end
  end
end
