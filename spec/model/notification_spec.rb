require 'spec_helper'

describe Notifiable::Notification do  
  describe "#add_device_token" do
    context "single token" do
      subject(:notification) { create(:notification, app: create(:app, save_notification_statuses: true)) }
      let(:dt) { create(:device_token, :locale => 'en') }
    
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
  
  describe "#params" do
    subject! { create(:notification, :parameters => {:custom_property => "A different message"}) }
    
    it { expect(subject.parameters).to eq({:custom_property => "A different message"}) }
  end
  
  describe "#destroy" do
    subject { create(:notification) }
    let!(:s) { create(:notification_status, :notification => subject) }
    
    before(:each) { subject.destroy }
    
    it { expect(Notifiable::NotificationStatus.count).to eq 0 }
  end
  
end