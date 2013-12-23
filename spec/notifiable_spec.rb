require 'spec_helper'

describe Notifiable::Concern do
  let(:user1) { FactoryGirl.build(:user_with_apns_token) }
  let(:notification) { Notifiable::Notification.new(:message => "Test message")}
  
  it "sends a single push notification" do    
    
    user1.send_notification(notification)
    
    Notifiable.deliveries.count.should == 1
  end
  
  it "sends zero notifications if the device is not valid" do
    user = FactoryGirl.build(:user_with_invalid_apns_token)
    
    user.send_notification(notification)
    
    Notifiable.deliveries.count.should == 0
  end
  
end