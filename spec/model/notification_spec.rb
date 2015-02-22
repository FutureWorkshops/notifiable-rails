require 'spec_helper'

describe Notifiable::Notification do
  
  describe "#create" do
    it { expect { create(:notification, :localized_notifications_attributes => [{:message => "Hello", :locale => :en}]) }.to change(Notifiable::LocalizedNotification, :count).by(1) }
    it { expect { create(:notification, :localized_notifications_attributes => [{:message => nil, :locale => :en}]) }.to change(Notifiable::LocalizedNotification, :count).by(0) }
  end

  describe "#localized_notifications" do
    subject(:n) { create(:notification) }
    let!(:localizations) { create_list(:localized_notification, 2, :notification => n)}

    it { expect(Notifiable::Notification.count).to eq 1 }    
    it { expect(Notifiable::Notification.first.localized_notifications.count).to eq 2 }
  end
  
  describe "#destroy" do
    subject(:n) { create(:localized_notification) }
    let!(:s) { create(:notification_status, :localized_notification => n) }
    
    before(:each) { n.destroy }
    
    it { expect(Notifiable::NotificationStatus.count).to eq 0 }
  end
  
  describe "#add_notifiable" do
    context "for a single user" do
      subject(:notification) { create(:notification_with_en_localization) }
      let(:u) { create(:user_with_en_token) }
    
      before(:each) do
        notification.batch do |n|
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
      subject(:notification) { create(:notification_with_en_localization) }
      let(:u1) { create(:user_with_en_token) }
      let(:u2) { create(:user_with_en_token) }
    
      before(:each) do
        notification.batch do |n|
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
      subject(:notification) { create(:notification_with_en_localization) }
      let(:dt) { create(:device_token, :locale => :en) }
    
      before(:each) { notification.batch {|n| n.add_device_token(dt) } }
    
      it { expect(Notifiable::Notification.first.sent_count).to eq 1 }
      it { expect(Notifiable::Notification.first.gateway_accepted_count).to eq 1 }
      it { expect(Notifiable::Notification.first.opened_count).to eq 0 }    
      it { expect(Notifiable::NotificationStatus.count).to eq 1 }  
      it { expect(Notifiable::NotificationStatus.first.status).to eq 0 }
      it { expect(Notifiable::NotificationStatus.first.created_at).to_not be_nil }
    end
    
    context "undefined provider" do
      subject(:notification) { create(:notification) }
      let(:dt) { create(:mock_token, :provider => :sms) }
      
      before(:each) do
        notification.batch do |n|      
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