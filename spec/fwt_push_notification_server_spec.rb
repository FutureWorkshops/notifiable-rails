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
    
    FwtPushNotificationServer.deliveries[0][:notification].apns_message.should eql "First test message"
    FwtPushNotificationServer.deliveries[0][:device_token].should eql user1.device_tokens[0]
    
    FwtPushNotificationServer.deliveries[1][:notification].apns_message.should eql "First test message"
    FwtPushNotificationServer.deliveries[1][:device_token].should eql user2.device_tokens[0]
  end
  
  it "sends two different push notifications" do
    FwtPushNotificationServer.batch do |b|
      b.add(notification1, user1)
      b.add(notification2, user2)
    end
    
    FwtPushNotificationServer.deliveries.count.should == 2
    
    FwtPushNotificationServer.deliveries[0][:notification].apns_message.should eql "First test message"
    FwtPushNotificationServer.deliveries[0][:device_token].should eql user1.device_tokens[0]
    
    FwtPushNotificationServer.deliveries[1][:notification].apns_message.should eql "Second test message"
    FwtPushNotificationServer.deliveries[1][:device_token].should eql user2.device_tokens[0]
  end
  
  it "doesnt send notifications if the delivery_method is set to :test" do
    FwtPushNotificationServer.delivery_method = :test
    
    user1.send_notification(notification1)
    
    FwtPushNotificationServer.deliveries.count.should == 1
    
    #Timeout.timeout(2) {
    #  @grocer.notifications.size.should == 0
    #}
  end
  
  it "truncates long apns messages" do
    
    long_notification = FwtPushNotificationServer::Notification.new(:message => "First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message end")
    
    
    user1.send_notification(long_notification)
    
    FwtPushNotificationServer.deliveries.count.should == 1
    FwtPushNotificationServer.deliveries[0][:notification].apns_message.should eql "First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message F..."
  end
end