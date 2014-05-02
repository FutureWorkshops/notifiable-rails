require 'spec_helper'

describe Notifiable::App do

  let(:notifiable_app) { FactoryGirl.create(:app, :configuration => {:configurable_mock => {:use_sandbox => true}}) }
  let(:notification) { FactoryGirl.create(:notification, :app => notifiable_app) }
  let(:notifier) { ConfigurableMockNotifier.new }
  
  it "contains notifications" do  
    notification.app.should_not be_nil
    notifiable_app.notifications.count.should == 1
  end
  
  it "configures a notifier" do  
    notifiable_app.configure :configurable_mock, notifier

    notifier.use_sandbox.should == true
  end
  
end

class ConfigurableMockNotifier < Notifiable::NotifierBase
  attr_accessor :use_sandbox
end