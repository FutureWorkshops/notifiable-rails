require 'spec_helper'

describe Notifiable::Batch do
  let(:user1) { FactoryGirl.create(:user) }
  let(:notification) { FactoryGirl.create(:notification, :app => app) }
  let(:app) { FactoryGirl.create(:app, :configuration => {:configurable_mock => {:use_sandbox => true}}) }
  
  it "adds a notifiable object" do  
    FactoryGirl.create(:mock_token, :provider => :configurable_mock, :user_id => user1.id, :app => app)
          
    b = Notifiable::Batch.new(app)
    b.add_notifiable(notification, user1)
    b.close

    Notifiable::NotificationStatus.count.should == 1
    saved_notification = Notifiable::Notification.first
    saved_notification.sent_count.should == 1
    saved_notification.gateway_accepted_count.should == 1
    saved_notification.opened_count.should == 0
    
    saved_status = Notifiable::NotificationStatus.first
    saved_status.status.should == 0
  end
  
  it "adds a device token" do  
    token = FactoryGirl.create(:mock_token, :provider => :configurable_mock, :user_id => user1.id, :app => app)
          
    b = Notifiable::Batch.new(app)
    b.add_device_token(notification, token)
    b.close

    Notifiable::NotificationStatus.count.should == 1
    saved_notification = Notifiable::Notification.first
    saved_notification.sent_count.should == 1
    saved_notification.gateway_accepted_count.should == 1
  end
  
  it "configures the provider via an App" do  
    FactoryGirl.create(:mock_token, :provider => :configurable_mock, :user_id => user1.id, :app => app)
    
    b = Notifiable::Batch.new(app)
    b.add_notifiable(notification, user1)

    b.notifiers[:configurable_mock].env.should eql Rails.env
    b.notifiers[:configurable_mock].use_sandbox.should == true
  end
  
end

module Notifiable
  class Batch
    attr_accessor :notifiers
  end
end

class ConfigurableMockNotifier < Notifiable::NotifierBase
  attr_accessor :use_sandbox
  
  def enqueue(notification, device_token)
    processed(notification, device_token, 0)
  end
end

Notifiable.notifier_classes[:configurable_mock] = ConfigurableMockNotifier