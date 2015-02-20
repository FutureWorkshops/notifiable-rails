require 'spec_helper'

describe Notifiable::Concern do
  let(:user1) { FactoryGirl.create(:user_with_mock_token) }
  let(:invalid_token_user) { FactoryGirl.create(:user_with_invalid_mock_token) }
  let(:notification1) { FactoryGirl.create(:notification, :message => "First test message")}
    
  it "sends a single push notification" do
    puts "**** #{Rails.configuration.database_configuration}"
          
    user1.send_notification(notification1)
    
    Notifiable::NotificationStatus.count.should == 1    
  end
  
  it "sends zero notifications if the device is not valid" do
    invalid_token_user.send_notification(notification1)
    
    Notifiable::NotificationStatus.count.should == 0    
  end
  
end