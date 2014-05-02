require 'spec_helper'

describe Notifiable::Notification do
  
  let(:user1) { FactoryGirl.create(:user_with_mock_token) }
  let(:user2) { FactoryGirl.create(:user_with_mock_token) }
  let(:notification1) { FactoryGirl.create(:notification, :message => "First test message")}
  let(:notification2) { FactoryGirl.create(:notification, :message => "Second test message")}
  
  it "stores a message" do    
    FactoryGirl.create(:notification, :message => "Test message")
    
    Notifiable::Notification.first.message.should eql "Test message"
  end
  
  it "stores params" do    
    FactoryGirl.create(:notification, :params => {:custom_property => "A different message"})
    
    Notifiable::Notification.first.params.should == {:custom_property => "A different message"}
  end
  
  it "destroys dependent NotificationStatuses" do
    n = FactoryGirl.create(:notification, :params => {:custom_property => "A different message"})
    Notifiable::NotificationStatus.create :notification => n
    
    n.destroy
    
    Notifiable::NotificationStatus.count.should == 0
  end
  
  it "adds a notifiable object" do            
    notification1.batch do |n|
      n.add_notifiable(user1)
    end

    Notifiable::NotificationStatus.count.should == 1
    saved_notification = Notifiable::Notification.first
    saved_notification.sent_count.should == 1
    saved_notification.gateway_accepted_count.should == 1
    saved_notification.opened_count.should == 0
    
    saved_status = Notifiable::NotificationStatus.first
    saved_status.status.should == 0
    saved_status.created_at.should_not be_nil
  end
  
  it "adds a device token" do  
    notification1.batch do |n|
      n.add_device_token(user1.device_tokens.first)
    end

    Notifiable::NotificationStatus.count.should == 1
    saved_notification = Notifiable::Notification.first
    saved_notification.sent_count.should == 1
    saved_notification.gateway_accepted_count.should == 1
  end
    
  it "sends a push notification to two users" do
    notification1.batch do |n|
      n.add_notifiable(user1)
      n.add_notifiable(user2)
    end

    Notifiable::NotificationStatus.count.should == 2
    
    all_notifications = Notifiable::NotificationStatus.all
    first_notification_token = all_notifications[0]
    first_notification_token.notification.message.should eql "First test message"
    first_notification_token.device_token.should eql user1.device_tokens[0]
    
    second_notification_token = all_notifications[1]
    second_notification_token.notification.message.should eql "First test message"
    second_notification_token.device_token.should eql user2.device_tokens[0]
  end
  
  it "sends separate push notifications" do
    notification1.batch do |n|
      n.add_notifiable(user1)
    end
    
    notification2.batch do |n|
      n.add_notifiable(user2)
    end
    
    Notifiable::NotificationStatus.count.should == 2
    
    all_notifications = Notifiable::NotificationStatus.all
    first_notification_token = all_notifications[0]
    first_notification_token.status.should == 0
    first_notification_token.notification.message.should eql "First test message"
    first_notification_token.device_token.should eql user1.device_tokens[0]
    
    second_notification_token = all_notifications[1]
    second_notification_token.status.should == 0
    second_notification_token.notification.message.should eql "Second test message"
    second_notification_token.device_token.should eql user2.device_tokens[0]
  end
  
  it "raises an error if it can't find the notification provider" do
    user = FactoryGirl.create(:user)
    device_token = FactoryGirl.create(:mock_token, :provider => :sms, :user_id => user.id)
    
    expect { user.send_notification(notification1) }.to raise_error    
  end
  
end