require 'spec_helper'

describe Notifiable::Concern do
    
  describe "#send_notification" do
    
    context "single" do
      let(:user1) { create(:user_with_mock_token) }
      let(:notification1) { create(:notification, :message => "First test message")} 
      
      before(:each) { user1.send_notification(notification1) }
      
      it { expect(Notifiable::NotificationStatus.count).to eq 1 }     
    end
    
    context "invalid device" do
      let(:user1) { FactoryGirl.create(:user_with_invalid_mock_token) }
      let(:notification1) { create(:notification, :message => "First test message")} 
    
      before(:each) { user1.send_notification(notification1) }
      
      it { expect(Notifiable::NotificationStatus.count).to eq 0 }     
    end    
  end
end