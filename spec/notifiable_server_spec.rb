require 'spec_helper'

describe Notifiable do
  let(:user1) { FactoryGirl.build(:user_with_apns_token) }
  let(:user2) { FactoryGirl.build(:user_with_apns_token) }
  let(:notification1) { Notifiable::Notification.new(:message => "First test message")}
  let(:notification2) { Notifiable::Notification.new(:message => "Second test message")}
  
  it "sends two identical push notifications" do
    Notifiable.batch do |b|
      b.add(notification1, user1)
      b.add(notification1, user2)
    end
    Notifiable.deliveries.count.should == 2
    
    Notifiable.deliveries[0][:notification].apns_message.should eql "First test message"
    Notifiable.deliveries[0][:device_token].should eql user1.device_tokens[0]
    
    Notifiable.deliveries[1][:notification].apns_message.should eql "First test message"
    Notifiable.deliveries[1][:device_token].should eql user2.device_tokens[0]
  end
  
  it "sends two different push notifications" do
    Notifiable.batch do |b|
      b.add(notification1, user1)
      b.add(notification2, user2)
    end
    
    Notifiable.deliveries.count.should == 2
    
    Notifiable.deliveries[0][:notification].apns_message.should eql "First test message"
    Notifiable.deliveries[0][:device_token].should eql user1.device_tokens[0]
    
    Notifiable.deliveries[1][:notification].apns_message.should eql "Second test message"
    Notifiable.deliveries[1][:device_token].should eql user2.device_tokens[0]
  end
  
  it "doesnt send notifications if the delivery_method is set to :test" do
    Notifiable.delivery_method = :test
    
    user1.send_notification(notification1)
    
    Notifiable.deliveries.count.should == 1
    
    #Timeout.timeout(2) {
    #  @grocer.notifications.size.should == 0
    #}
  end
  
  it "truncates long apns messages" do
    
    long_notification = Notifiable::Notification.new(:message => "First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message end")
    
    
    user1.send_notification(long_notification)
    
    Notifiable.deliveries.count.should == 1
    Notifiable.deliveries[0][:notification].apns_message.should eql "First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message F..."
  end
end