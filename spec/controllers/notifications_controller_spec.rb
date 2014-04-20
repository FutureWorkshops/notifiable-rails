require 'spec_helper'

describe Notifiable::NotificationsController do
  
  let(:user1) { FactoryGirl.create(:user_with_mock_token) }
  let(:user1_device_token) { user1.device_tokens.first }
  let(:user2) { FactoryGirl.create(:user) }
  let(:app) { user1_device_token.app }
  let(:notification) { FactoryGirl.create(:notification, :app => app)}
  let(:anonymous_device_token) { FactoryGirl.create(:mock_token) }
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
    @request.env["CONTENT_TYPE"] = "application/json"
  end

  it "marks a status as opened" do
    FactoryGirl.create(:notification_status, :notification => notification, :device_token => user1_device_token)
    
    put :opened, {:notification_id => notification.id, :device_token_id => user1_device_token.id, :user_email => user1.email}
    
    response.status.should == 200
    
    Notifiable::NotificationStatus.count.should == 1
    saved_status = Notifiable::NotificationStatus.first
    saved_status.opened?.should be_true
    
    Notifiable::Notification.count.should == 1
    saved_notification = Notifiable::Notification.first
    saved_notification.opened_count.should == 1
  end
  
  it "marks a status as opened anonymously" do
    FactoryGirl.create(:notification_status, :notification => notification, :device_token => anonymous_device_token)
    
    put :opened, {:notification_id => notification.id, :device_token_id => anonymous_device_token.id}
    
    response.status.should == 200
    
    Notifiable::NotificationStatus.count.should == 1
    saved_status = Notifiable::NotificationStatus.first
    saved_status.opened?.should be_true
    
    Notifiable::Notification.count.should == 1
    saved_notification = Notifiable::Notification.first
    saved_notification.opened_count.should == 1
  end
  
  it "returns an error if the user is incorrect" do
    FactoryGirl.create(:notification_status, :notification => notification, :device_token => user1_device_token)
    
    post :opened, {:notification_id => notification.id, :device_token_id => user1_device_token.id, :user_email => user2.email}
    
    response.status.should == 401
    
    Notifiable::NotificationStatus.count.should == 1
    saved_status = Notifiable::NotificationStatus.first
    saved_status.status.should == 0
    
    Notifiable::Notification.count.should == 1
    saved_notification = Notifiable::Notification.first
    saved_notification.opened_count.should == 0
  end
  
end