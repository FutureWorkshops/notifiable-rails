require 'spec_helper'

class User < ActiveRecord::Base
  devise :notifiable
end

describe User do
  let(:user) { FactoryGirl.build(:user_with_apns_token) }
  
  it "sends a single push notification" do
        
    user.notify_once "Test"
    
    FwtPushNotificationServer.deliveries[:apns].count.should == 1
  end
end