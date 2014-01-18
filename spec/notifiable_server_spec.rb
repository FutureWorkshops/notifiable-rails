require 'spec_helper'

describe Notifiable do
  let(:user1) { FactoryGirl.create(:user_with_mock_token) }
  let(:user2) { FactoryGirl.create(:user_with_mock_token) }
  let(:notification1) { Notifiable::Notification.create(:message => "First test message")}
  let(:notification2) { Notifiable::Notification.create(:message => "Second test message")}
  
  it "sends two identical push notifications" do
    Notifiable.batch do |b|
      b.add(notification1, user1)
      b.add(notification1, user2)
    end
    Notifiable::NotificationDeviceToken.count.should == 2
    
    all_notifications = Notifiable::NotificationDeviceToken.all
    first_notification_token = all_notifications[0]
    first_notification_token.notification.apns_message.should eql "First test message"
    first_notification_token.device_token.should eql user1.device_tokens[0]
    
    second_notification_token = all_notifications[1]
    second_notification_token.notification.apns_message.should eql "First test message"
    second_notification_token.device_token.should eql user2.device_tokens[0]
  end
  
  it "sends two different push notifications" do
    Notifiable.batch do |b|
      b.add(notification1, user1)
      b.add(notification2, user2)
    end
    
    Notifiable::NotificationDeviceToken.count.should == 2
    
    all_notifications = Notifiable::NotificationDeviceToken.all
    first_notification_token = all_notifications[0]
    first_notification_token.notification.apns_message.should eql "First test message"
    first_notification_token.device_token.should eql user1.device_tokens[0]
    
    second_notification_token = all_notifications[1]
    second_notification_token.notification.apns_message.should eql "Second test message"
    second_notification_token.device_token.should eql user2.device_tokens[0]
  end
  
  it "truncates long apns messages" do
    
    long_notification = Notifiable::Notification.create(:message => "First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message end")
    
    user1.send_notification(long_notification)
    
    Notifiable::NotificationDeviceToken.count.should == 1
    
    all_notifications = Notifiable::NotificationDeviceToken.all
    first_notification_token = all_notifications[0]
    first_notification_token.notification.apns_message.should eql "First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message First test message F..."
  end
  
  it "raises an error if it can't find the notification provider" do
    user = FactoryGirl.create(:user)
    Notifiable::DeviceToken.create :user_id => user.email, :token => "DEF567", :provider => :gcm
    
    expect { user.send_notification(notification1) }.to raise_error    
  end
end