require 'spec_helper'

describe Notifiable::Concern do
  let(:user1) { FactoryGirl.create(:user_with_mock_token) }
  let(:notification) { Notifiable::Notification.new(:message => "Test message")}
  
  it "sends a single push notification" do    
    
    user1.send_notification(notification)
    
    Notifiable::NotificationStatus.count.should == 1    
  end
  
  it "sends zero notifications if the device is not valid" do
    user = FactoryGirl.build(:user_with_invalid_mock_token)
    
    user.send_notification(notification)
    
    Notifiable::NotificationStatus.count.should == 0    
  end
  
end