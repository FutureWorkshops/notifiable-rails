require 'spec_helper'

describe FwtPushNotificationServer::Notifiable do
  let(:user1) { FactoryGirl.build(:user_with_apns_token) }
  let(:notification) { FwtPushNotificationServer::Notification.new(:message => "Test message")}
  
  it "sends a single push notification" do    
    
    user1.send_notification(notification)
    
    FwtPushNotificationServer.deliveries.count.should == 1
  end
  
  it "sends zero notifications if the device is not valid" do
    user = FactoryGirl.build(:user_with_invalid_apns_token)
    
    user.send_notification(notification)
    
    FwtPushNotificationServer.deliveries.count.should == 0
  end
  
end