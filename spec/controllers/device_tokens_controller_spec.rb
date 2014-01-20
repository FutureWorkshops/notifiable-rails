require 'spec_helper'

describe Notifiable::DeviceTokensController do
  
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user_with_mock_token) }
  let(:user2_device_token) { user2.device_tokens.first }
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
    @request.env["CONTENT_TYPE"] = "application/json"
  end

  it "creates a new device token for a valid user" do
    post :create, :token => "ABC123", :user_email => user1.email, :provider => :apns
    
    expect(response).to be_success
    
    Notifiable::DeviceToken.count.should == 1
    user1.device_tokens.count.should == 1
    user1.device_tokens.first.token.should.eql? "ABC123"
    user1.device_tokens.first.provider.should.eql? :apns    
  end
  
  it "creates a new device token for an anonymous" do
    post :create, :token => "ABC123", :provider => :apns
    
    expect(response).to be_success
    
    Notifiable::DeviceToken.count.should == 1
    Notifiable::DeviceToken.first.token.should.eql? "ABC123"
    Notifiable::DeviceToken.first.provider.should.eql? :apns   
    User.count.should == 0 
  end

  it "deletes tokens" do
    delete :destroy, :token => user2_device_token.token, :user_email => user2.email
    
    expect(response).to be_success
    Notifiable::DeviceToken.where(:token => user2_device_token.token).count.should == 0
  end

  it "doesn't delete tokens for anonymous users" do
  	delete :destroy, :token => user2_device_token.token
    
  	expect(response.status).to eq(406)
  	Notifiable::DeviceToken.where(:token => user2_device_token.token).count.should == 1
  end
  
  it "doesn't delete tokens for other users" do
  	delete :destroy, :token => user2_device_token.token, :user_email => user1.email
    
  	expect(response.status).to eq(401)
  	Notifiable::DeviceToken.where(:token => user2_device_token.token).count.should == 1
  end
  
  it "returns not found if the token doesnt exist" do
  	delete :destroy, :token => "ZXY987", :user_email => user1.email
    
  	expect(response.status).to eq(404)
  	Notifiable::DeviceToken.where(:token => user2_device_token.token).count.should == 1
  end
  
end