require 'spec_helper'

describe User do
  let(:user1) { FactoryGirl.build(:user_with_apns_token) }
  let(:user2) { FactoryGirl.build(:user_with_apns_token) }
  
  it "sends a single push notification" do
    user1.notify_once "Test"
    
    FwtPushNotificationServer.deliveries.count.should == 1
  end
  
  it "sends two push notifications at once" do
    FwtPushNotificationServer.begin_transaction("Test push message") do
      user1.schedule_notification
      user2.schedule_notification
    end
    FwtPushNotificationServer.deliveries.count.should == 1
    FwtPushNotificationServer.deliveries[0].recipients.count.should == 2
  end
  
  it "sends zero notifications if the device is not valid" do
    user = FactoryGirl.build(:user_with_invalid_apns_token)
    
    user.notify_once "Test"
    
    FwtPushNotificationServer.deliveries.count.should == 0
  end
  
  it "doesn't send multiple notifications to the same device" do
    
    FwtPushNotificationServer.begin_transaction("Test push message") do
      user1.schedule_notification
      user1.schedule_notification
    end
    
    FwtPushNotificationServer.deliveries.count.should == 1
    FwtPushNotificationServer.deliveries[0].recipients.count.should == 1
    
  end
  
end