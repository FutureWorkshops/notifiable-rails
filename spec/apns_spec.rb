require 'spec_helper'

describe FwtPushNotificationServer::Notifier::APNS do
  let(:user1) { FactoryGirl.build(:user_with_apns_token) }
  let(:notification) { FwtPushNotificationServer::Notification.new(:message => "Test message")}
  
  it "sends a single grocer notification" do    
    
    user1.send_notification(notification)
    
    Timeout.timeout(3) {
      notification = @grocer.notifications.pop
      notification.alert.should eql "Test message"
    }
  end
  
end