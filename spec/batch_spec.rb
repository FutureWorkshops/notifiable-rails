require 'spec_helper'

describe Notifiable::Batch do
  let(:user1) { FactoryGirl.create(:user) }
  let(:notification) { Notifiable::Notification.new(:message => "Test message")}
  let(:app) { FactoryGirl.create(:app, :configuration => {:configurable_mock => {:use_sandbox => true}}) }
  
  it "adds a notifiable object" do  
    FactoryGirl.create(:mock_token, :provider => :configurable_mock, :user_id => user1.id)
          
    b = Notifiable::Batch.new(app)
    b.add_notifiable(notification, user1)

    Notifiable::NotificationStatus.count == 1
  end
  
  it "adds a device token" do  
    FactoryGirl.create(:mock_token, :provider => :configurable_mock, :user_id => user1.id)
          
    b = Notifiable::Batch.new(app)
    b.add_device_token(notification, user1.device_tokens.first)

    Notifiable::NotificationStatus.count == 1
  end
  
  it "configures the provider via an App" do  
    FactoryGirl.create(:mock_token, :provider => :configurable_mock, :user_id => user1.id)

    
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
    processed(notification, device_token, 200)
  end
end

Notifiable.notifier_classes[:configurable_mock] = ConfigurableMockNotifier