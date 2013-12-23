require 'spec_helper'

describe Notifiable::Notifier::GCM do
  let(:user1) { FactoryGirl.build(:user_with_gcm_token) }
  let(:notification) { Notifiable::Notification.new(:message => "Test message")}
  
  it "sends a single GCM notification" do    
    
    user1.send_notification(notification)
    
    # todo pending - add a dummy GCM server
    Notifiable.deliveries.count.should == 1
    
  end
  
end