require 'spec_helper'

describe Notifiable::Batch do
  let(:user1) { FactoryGirl.create(:user) }
  let(:notification) { Notifiable::Notification.new(:message => "Test message")}
  
  it "configures the provider" do  
    FactoryGirl.create(:mock_token, :provider => :configurable_mock, :user_id => user1.id)
      
    config = {:configurable_mock => {:use_sandbox => true}}
    
    b = Notifiable::Batch.new(config)
    b.add(notification, user1)

    b.notifiers[:configurable_mock].env.should eql Rails.env
    b.notifiers[:configurable_mock].use_sandbox.should == true
  end
  
end

class ConfigurableMockNotifier < Notifiable::NotifierBase
  attr_accessor :use_sandbox
  
  def enqueue(notification, device_token)
    processed(notification, device_token, 200)
  end
end

Notifiable.notifier_classes[:configurable_mock] = ConfigurableMockNotifier