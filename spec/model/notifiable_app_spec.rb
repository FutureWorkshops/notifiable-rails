require 'spec_helper'

describe Notifiable::App do
  describe "#notifications" do
    subject(:notifiable_app) { create(:app) }
    let!(:notification) { create(:notification, :app => notifiable_app) }
    
    it { expect(notification.app).to_not be_nil }
    it { expect(notifiable_app.notifications.count).to eq 1 }
  end
  
  describe "#configure" do
    let(:notification) { create(:notification, :app => notifiable_app) }
    let(:notifier) { ConfigurableMockNotifier.new(Rails.env, notification) }
    subject(:notifiable_app) { create(:app, :configuration => {:configurable_mock => {:use_sandbox => true}}) }
    
    before(:each) { notifiable_app.configure :configurable_mock, notifier }
    
    it { expect(notifier.use_sandbox).to eq true }
  end
end