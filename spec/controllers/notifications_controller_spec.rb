require 'spec_helper'

describe Notifiable::NotificationsController do
  
  let(:user1) { FactoryGirl.create(:user_with_mock_token) }
  let(:user1_device_token) { user1.device_tokens.first }
  let(:user2) { FactoryGirl.create(:user) }
  let(:app) { user1_device_token.app }
  let(:notification) { FactoryGirl.create(:notification, :app => app)}
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
    @request.env["CONTENT_TYPE"] = "application/json"
  end

  it "marks a status as opened" do
    FactoryGirl.create(:notification_status, :notification => notification, :device_token => user1_device_token)
    
    put :opened, {:notification_id => notification.id, :device_token => {:token => user1_device_token.token}, :user_email => user1.email}
    
    expect(response).to be_success
    
    Notifiable::NotificationStatus.count.should == 1
    saved_status = Notifiable::NotificationStatus.first
    saved_status.opened?.should be_true
    
    Notifiable::Notification.count.should == 1
    saved_notification = Notifiable::Notification.first
    saved_notification.opened_count.should == 1
  end
  
  it "returns an error if the user is incorrect" do
    FactoryGirl.create(:notification_status, :notification => notification, :device_token => user1_device_token)
    
    post :opened, {:notification_id => notification.id, :device_token => {:token => user1_device_token.token}, :user_email => user2.email}
    
  	expect(response.status).to eq(406)
    
    Notifiable::NotificationStatus.count.should == 1
    saved_status = Notifiable::NotificationStatus.first
    saved_status.status.should == 0
    
    Notifiable::Notification.count.should == 1
    saved_notification = Notifiable::Notification.first
    saved_notification.opened_count.should == 0
  end
  
end