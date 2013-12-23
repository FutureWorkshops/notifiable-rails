require 'spec_helper'

describe FwtPushNotificationServer::DeviceTokensController do
  
  let(:user1) { FactoryGirl.create(:user) }
  
  it "creates a new device token" do    
    
    post :create, :token => "ABC123", :user_id => user1.email, :provider => :apns
    FwtPushNotificationServer::DeviceToken.count.should == 1
    
  end
  
end