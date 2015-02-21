require 'spec_helper'

describe Notifiable::Notification do
  
  let(:user1) { FactoryGirl.create(:user_with_mock_token) }
  let(:user2) { FactoryGirl.create(:user_with_mock_token) }
  let(:notification1) { FactoryGirl.create(:notification, :message => "First test message")}
  let(:notification2) { FactoryGirl.create(:notification, :message => "Second test message")}
  
  describe "#message" do
    subject!(:n) { create(:notification, :message => "Test message") }
    
    it { expect(Notifiable::Notification.first.message).to eq "Test message" }
  end
  
  describe "#params" do
    subject!(:n) { create(:notification, :params => {:custom_property => "A different message"}) }
    
    it { expect(Notifiable::Notification.first.params).to eq({:custom_property => "A different message"}) }
  end
  
  describe "#destroy" do
    subject(:n) { create(:notification) }
    let!(:s) { create(:notification_status, :notification => n) }
    
    before(:each) { n.destroy }
    
    it { expect(Notifiable::NotificationStatus.count).to eq 0 }
  end
  
  describe "#add_notifiable" do
    context "for a single user" do
      subject(:notification) { create(:notification) }
      let(:u) { create(:user_with_mock_token) }
    
      before(:each) do
        notification1.batch do |n|
          n.add_notifiable(u)
        end      
      end
    
      it { expect(Notifiable::Notification.first.sent_count).to eq 1 }
      it { expect(Notifiable::Notification.first.gateway_accepted_count).to eq 1 }
      it { expect(Notifiable::Notification.first.opened_count).to eq 0 }    
      it { expect(Notifiable::NotificationStatus.count).to eq 1 }  
      it { expect(Notifiable::NotificationStatus.first.status).to eq 0 }
      it { expect(Notifiable::NotificationStatus.first.created_at).to_not be_nil }
    end
    
    context "for two users" do
      subject(:notification) { create(:notification) }
      let(:u1) { create(:user_with_mock_token) }
      let(:u2) { create(:user_with_mock_token) }
    
      before(:each) do
        notification1.batch do |n|
          n.add_notifiable(u1)
          n.add_notifiable(u2)
        end      
      end
    
      it { expect(Notifiable::Notification.first.sent_count).to eq 2 }
      it { expect(Notifiable::Notification.first.gateway_accepted_count).to eq 2 }
      it { expect(Notifiable::Notification.first.opened_count).to eq 0 }    
      it { expect(Notifiable::NotificationStatus.count).to eq 2 }  
      it { expect(Notifiable::NotificationStatus.first.status).to eq 0 }
      it { expect(Notifiable::NotificationStatus.first.created_at).to_not be_nil }
      it { expect(Notifiable::NotificationStatus.last.status).to eq 0 }
      it { expect(Notifiable::NotificationStatus.last.created_at).to_not be_nil }
    end 
  
  end
  
  describe "#add_device_token" do
    context "single token" do
      subject(:n) { create(:notification) }
      let(:dt) { create(:mock_token) }
    
      before(:each) { notification1.batch {|n| n.add_device_token(dt) } }
    
      it { expect(Notifiable::Notification.first.sent_count).to eq 1 }
      it { expect(Notifiable::Notification.first.gateway_accepted_count).to eq 1 }
      it { expect(Notifiable::Notification.first.opened_count).to eq 0 }    
      it { expect(Notifiable::NotificationStatus.count).to eq 1 }  
      it { expect(Notifiable::NotificationStatus.first.status).to eq 0 }
      it { expect(Notifiable::NotificationStatus.first.created_at).to_not be_nil }
    end
    
    context "undefined provider" do
      subject(:n) { create(:notification) }
      let(:dt) { create(:mock_token, :provider => :sms) }
      
      before(:each) do
        notification1.batch do |n|      
          begin    
            n.add_device_token(unconfigured_device_token)
          rescue
          end      
        end
      end

      it { expect(Notifiable::NotificationStatus.count).to eq 0 }
    end   
  end
end