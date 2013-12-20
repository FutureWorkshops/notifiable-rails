require 'spec_helper'

describe FwtPushNotificationServer::Batch::Public do
  let(:user1) { FactoryGirl.build(:user_with_apns_token) }
  let(:user2) { FactoryGirl.build(:user_with_apns_token) }
  let(:notification) { FwtPushNotificationServer::Notification.new(:message => "Test message")}
  
  it "sends two push notifications at once" do
    FwtPushNotificationServer::Batch::Public.begin(:notification => notification) do |t|
      t.add_user(user1)
      t.add_user(user2)
    end
    FwtPushNotificationServer.deliveries.count.should == 1
    FwtPushNotificationServer.deliveries[0].device_tokens.count.should == 2
    FwtPushNotificationServer.deliveries[0].notification.message.should eql "Test message"
    
  end
  
  it "doesn't send multiple notifications to the same device" do
    
    FwtPushNotificationServer::Batch::Public.begin(:notification => notification) do |t|
      t.add_user(user1)
      t.add_user(user1)
    end
    
    FwtPushNotificationServer.deliveries.count.should == 1
    FwtPushNotificationServer.deliveries[0].device_tokens.count.should == 1
    FwtPushNotificationServer.deliveries[0].notification.message.should eql "Test message"
    
  end
  
end