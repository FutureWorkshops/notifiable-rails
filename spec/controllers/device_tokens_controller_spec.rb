require 'spec_helper'

describe Notifiable::DeviceTokensController do
  
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user_with_apns_token) }

  it "creates a new device token" do    
    post :create, :token => "ABC123", :user_id => user1.email, :provider => :apns
    Notifiable::DeviceToken.count.should == 1
    Notifiable::DeviceToken.first.user_id.should eql user1.email
  end

  it "releases the token" do
    token = user2.device_tokens.first
    token.user_id.should_not be_nil
    delete :destroy, :id => token.token
    Notifiable::DeviceToken.find_by(:token => token.token).user_id.should be_nil
  end

  it "updates user attributes" do    
    pending("update the test app to include first name/last name for user")
  end
  
end