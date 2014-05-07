require 'spec_helper'

describe Notifiable::Concern do
  let(:user1) { FactoryGirl.create(:user_with_mock_token) }
  let(:notification1) { FactoryGirl.create(:notification, :message => "First test message")}
    
  it "sends a single push notification" do        
    user1.send_notification(notification1)
    
    Notifiable::NotificationStatus.count.should == 1    
  end
end