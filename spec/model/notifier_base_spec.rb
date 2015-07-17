require 'spec_helper'

describe Notifiable::NotifierBase do

  describe "#test_env?" do
    let(:notifiable_app) { FactoryGirl.create(:app, :configuration => {:configurable_mock => {:use_sandbox => true}}) }
    let(:notification) { FactoryGirl.create(:notification, :app => notifiable_app) }
    subject(:notifier) { ConfigurableMockNotifier.new(Rails.env, notification) }
    
    before(:each) { ConfigurableMockNotifier.send(:public, *ConfigurableMockNotifier.protected_instance_methods) }  

    it { expect(notifier.test_env?).to eq true }
  end
  
  describe "#processed" do
    let(:notifiable_app) { FactoryGirl.create(:app, :configuration => {:configurable_mock => {:use_sandbox => true}}) }
    let(:notification) { FactoryGirl.create(:notification_with_en_localization, :app => notifiable_app) }
    
    let(:device_token1) { FactoryGirl.create(:device_token, :app => notifiable_app, :locale => :en) }
    let(:device_token2) { FactoryGirl.create(:device_token, :app => notifiable_app, :locale => :en) }
    let(:device_token3) { FactoryGirl.create(:device_token, :app => notifiable_app, :locale => :en) }
    
    subject(:notifier) { ConfigurableMockNotifier.new(Rails.env, notification) }
    
    before(:each) do
      ConfigurableMockNotifier.send(:public, *ConfigurableMockNotifier.protected_instance_methods)
      
      Notifiable.notification_status_batch_size = 2
      notifier.processed(device_token1, 0)
      notifier.processed(device_token2, 0)
    end

    it { expect(Notifiable::NotificationStatus.count).to eq 2 }
    it { expect(notification.sent_count).to eq 2 }
    
  end
  
  
end

class ConfigurableMockNotifier < Notifiable::NotifierBase
  attr_accessor :use_sandbox
end