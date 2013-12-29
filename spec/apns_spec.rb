require 'spec_helper'

describe Notifiable::Notifier::APNS do
  let(:user1) { FactoryGirl.build(:user_with_apns_token) }
  let(:notification) { Notifiable::Notification.new(:message => "Test message")}
  
  it "sends a single grocer notification" do    
    
    user1.send_notification(notification)
        
    Notifiable::NotificationDeviceToken.count.should == 1
    
    #Timeout.timeout(2) {
    #  notification = @grocer.notifications.pop
    #  notification.alert.should eql "Test message"
    #}
  end
  
end