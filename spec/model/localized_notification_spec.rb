require 'spec_helper'

describe Notifiable::LocalizedNotification do

  describe "#locale" do
    subject!(:l) { create(:localized_notification, :locale => 'en') }
    
    it { expect(Notifiable::LocalizedNotification.first.locale).to eq 'en' }
  end
  
  describe "#message" do
    context "valid" do
      subject!(:l) { create(:localized_notification, :message => "Test message") }
    
      it { expect(Notifiable::LocalizedNotification.first.message).to eq "Test message" }
    end
    
    context "empty" do
      subject!(:l) { build(:localized_notification, :message => nil) } 
           
      it { expect{ l.save! }.to raise_error ActiveRecord::RecordInvalid }      
    end
  end
  
  describe "#params" do
    subject!(:l) { create(:localized_notification, :params => {:custom_property => "A different message"}) }
    
    it { expect(Notifiable::LocalizedNotification.first.params).to eq({:custom_property => "A different message"}) }
  end
  
  describe "#notification" do
    let(:n) {create(:notification)}
    subject!(:l) { create(:localized_notification, :notification => n) }
    
    it { expect(Notifiable::LocalizedNotification.first.notification).to eq n }
  end
  
  describe "#destroy" do
    subject(:l) { create(:localized_notification) }
    let!(:s) { create(:notification_status, :localized_notification => l) }
    
    before(:each) { l.destroy }
    
    it { expect(Notifiable::NotificationStatus.count).to eq 0 }
  end
end