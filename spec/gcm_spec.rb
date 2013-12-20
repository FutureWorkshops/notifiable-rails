require 'spec_helper'

describe FwtPushNotificationServer::Notifier::GCM do
  let(:user1) { FactoryGirl.build(:user_with_gcm_token) }
  let(:notification) { FwtPushNotificationServer::Notification.new(:message => "Test message")}
  
  it "sends a single GCM notification" do    
    
    user1.send_notification(notification)
    
    # todo pending - add a dummy GCM server
    FwtPushNotificationServer.deliveries.count.should == 1
    
  end
  
end