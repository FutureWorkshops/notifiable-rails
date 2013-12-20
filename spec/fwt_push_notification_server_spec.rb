require 'spec_helper'

describe FwtPushNotificationServer do
  let(:user1) { FactoryGirl.build(:user_with_apns_token) }
  let(:user2) { FactoryGirl.build(:user_with_apns_token) }
  let(:notification1) { FwtPushNotificationServer::Notification.new(:message => "First test message")}
  let(:notification2) { FwtPushNotificationServer::Notification.new(:message => "Second test message")}
  
  it "sends two identical push notifications" do
    FwtPushNotificationServer.batch do |b|
      b.add(notification1, user1)
      b.add(notification1, user2)
    end
    FwtPushNotificationServer.deliveries.count.should == 2
    
    FwtPushNotificationServer.deliveries[0][:notification].message.should eql "First test message"
    FwtPushNotificationServer.deliveries[0][:device_token].should eql user1.device_tokens[0]
    
    FwtPushNotificationServer.deliveries[1][:notification].message.should eql "First test message"
    FwtPushNotificationServer.deliveries[1][:device_token].should eql user2.device_tokens[0]
  end
  
  it "sends two different push notifications" do
    FwtPushNotificationServer.batch do |b|
      b.add(notification1, user1)
      b.add(notification2, user2)
    end
    
    FwtPushNotificationServer.deliveries.count.should == 2
    
    FwtPushNotificationServer.deliveries[0][:notification].message.should eql "First test message"
    FwtPushNotificationServer.deliveries[0][:device_token].should eql user1.device_tokens[0]
    
    FwtPushNotificationServer.deliveries[1][:notification].message.should eql "Second test message"
    FwtPushNotificationServer.deliveries[1][:device_token].should eql user2.device_tokens[0]
  end
end