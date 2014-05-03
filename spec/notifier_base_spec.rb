require 'spec_helper'

describe Notifiable::NotifierBase do

  let(:notifiable_app) { FactoryGirl.create(:app, :configuration => {:configurable_mock => {:use_sandbox => true}}) }
  let(:notification) { FactoryGirl.create(:notification, :app => notifiable_app) }
  let(:notifier) { ConfigurableMockNotifier.new(Rails.env, notification) }
  
  before(:each) do
    ConfigurableMockNotifier.send(:public, *ConfigurableMockNotifier.protected_instance_methods)  
  end
  
  it "knows if the environment is test" do  
    notifier.test_env?.should == true
  end
  
  it "configures a notifier" do  
    notifiable_app.configure :configurable_mock, notifier

    notifier.use_sandbox.should == true
  end
  
end

class ConfigurableMockNotifier < Notifiable::NotifierBase
  attr_accessor :use_sandbox
end