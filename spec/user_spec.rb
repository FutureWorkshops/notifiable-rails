require 'spec_helper'

describe User do
  let(:user1) { FactoryGirl.build(:user_with_apns_token) }
  
  it "sends a single push notification" do    
    
    user1.notify_once "Test"
    
    FwtPushNotificationServer.deliveries.count.should == 1
  end
  
  it "sends zero notifications if the device is not valid" do
    user = FactoryGirl.build(:user_with_invalid_apns_token)
    
    user.notify_once "Test"
    
    FwtPushNotificationServer.deliveries.count.should == 0
  end
  
end