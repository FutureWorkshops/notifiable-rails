require 'spec_helper'

describe Notifiable::DeviceTokensController do
  
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user_with_mock_token) }
  let(:device_token) { user2.device_tokens.first }

  it "creates a new device token" do
  	controller.instance_variable_set(:@current_user, user1)
    post :create, :token => "ABC123", :user_id => user1.email, :provider => :apns
    expect(response).to be_success
    Notifiable::DeviceToken.count.should == 1
    Notifiable::DeviceToken.first.user_id.should eql user1.email
  end

  it "doesn't register tokens for unathorised users" do
  	controller.instance_variable_set(:@current_user, user1)
  	post :create, :token => "ABC123", :user_id => user2.email, :provider => :apns
  	expect(response.status).to eq(401)
  end

  it "doesn't release tokens for unathorised users" do
  	controller.instance_variable_set(:@current_user, user1)
  	delete :destroy, :id => device_token.token, :user_id => user2.email
  	expect(response.status).to eq(401)
  	Notifiable::DeviceToken.find_by(:token => device_token.token).user_id.should_not be_nil
  end

  it "doesn't release tokens for blank user_id" do
  	controller.instance_variable_set(:@current_user, user1)
  	delete :destroy, :id => device_token.token
  	expect(response.status).to eq(401)
  	Notifiable::DeviceToken.find_by(:token => device_token.token).user_id.should_not be_nil
  end

  it "releases the token" do
    device_token.user_id.should_not be_nil
    controller.instance_variable_set(:@current_user, user2)
    delete :destroy, :id => device_token.token, :user_id => user2.email
    expect(response).to be_success
    Notifiable::DeviceToken.find_by(:token => device_token.token).user_id.should be_nil
  end

  it "updates user attributes" do    
    pending("update the test app to include first name/last name for user")
  end
  
end