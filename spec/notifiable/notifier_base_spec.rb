require 'spec_helper'

describe Notifiable::NotifierBase do

  before(:each) { ConfigurableMockNotifier.send(:public, *ConfigurableMockNotifier.protected_instance_methods) }  
  let(:notification) { FactoryGirl.create(:notification, :app => notifiable_app) }
  
  describe "#notifier_attributes" do
    let(:notifiable_app) { FactoryGirl.create(:app, :configuration => {:configurable_mock => {:use_sandbox => true}}) }
    subject { ConfigurableMockNotifier.new(notification) }
    
    context "single" do
      it { expect(ConfigurableMockNotifier.notifier_attributes).to eq [:use_sandbox]}      
    end
    
    context "set" do
      before(:each) { ConfigurableMockNotifier.new(notification) }
      
      it { expect(ConfigurableMockNotifier.notifier_attributes).to eq [:use_sandbox]}      
    end
    
  end
  
  describe "#processed" do
    let(:notification) { FactoryGirl.create(:notification, :app => notifiable_app) }
  
    let(:device_token1) { FactoryGirl.create(:device_token, :app => notifiable_app, :locale => 'en') }
    let(:device_token2) { FactoryGirl.create(:device_token, :app => notifiable_app, :locale => 'en') }
    let(:device_token3) { FactoryGirl.create(:device_token, :app => notifiable_app, :locale => 'en') }

    subject(:notifier) { ConfigurableMockNotifier.new(notification) }
    
    before(:each) { Notifiable.notification_status_batch_size = 2 }  
    
    context "saving receipts by default" do
      let(:notifiable_app) { FactoryGirl.create(:app, :configuration => {:configurable_mock => {:use_sandbox => true}}) }
      
      before(:each) do
        notifiable_app.save_notification_statuses = true
             
        notifier.processed(device_token1, 0)
        notifier.processed(device_token2, 0)
      end

      it { expect(Notifiable::NotificationStatus.count).to eq 2 }
      it { expect(Notifiable::Notification.first.sent_count).to eq 2 }
    end
    
    context "not saving statuses" do  
      let(:notifiable_app) { FactoryGirl.create(:app, :configuration => {:save_notification_statuses => false, :configurable_mock => {:use_sandbox => true}}) }
        
      before(:each) do
        notifier.processed(device_token1, 0)
        notifier.processed(device_token2, 0)
      end

      it { expect(Notifiable::NotificationStatus.count).to eq 0 }
      it { expect(Notifiable::Notification.first.sent_count).to eq 2 }
    end
  end
end