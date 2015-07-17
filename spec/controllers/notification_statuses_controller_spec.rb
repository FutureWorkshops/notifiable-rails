require 'spec_helper'

describe Notifiable::NotificationStatusesController do
  
  #let(:user1_device_token) { user1.device_tokens.first }
  #let(:user2) { create(:user) }
  #let(:anonymous_device_token) { create(:mock_token) }
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
    @request.env["CONTENT_TYPE"] = "application/json"
  end
  
  describe "#opened" do
    
    describe "by a user" do
      
      context "authorised" do
        let(:notifiable_app) { create(:app) }
        let(:user) { create(:user) }
        let(:token) { create(:mock_token, :app => notifiable_app, :user_id => user.id) }
        let(:localized_notification) { create(:localized_notification, :locale => :en) }
        subject!(:status) { create(:notification_status, :localized_notification => localized_notification, :device_token => token) }
      
        before(:each) { put :opened, {:localized_notification_id => localized_notification.id, :device_token_id => token.id, :user_email => user.email} }
      
        it { expect(Notifiable::NotificationStatus.count).to eq 1 }
        it { expect(Notifiable::NotificationStatus.first.opened?).to eq true }
        it { expect(Notifiable::Notification.first.opened_count).to eq 1 }
      end
      
      context "unauthorised" do
        let(:notifiable_app) { create(:app) }
        let(:user1) { create(:user) }
        let(:user2) { create(:user) }
        let(:token) { create(:mock_token, :app => notifiable_app, :user_id => user1.id) }
        let(:localized_notification) { create(:localized_notification, :locale => :en) }
        subject!(:status) { create(:notification_status, :localized_notification => localized_notification, :device_token => token) }
              
        before(:each) { put :opened, {:localized_notification_id => localized_notification.id, :device_token_id => token.id, :user_email => user2.email} }

        it { expect(response.status).to eq 401 }      
        it { expect(Notifiable::NotificationStatus.count).to eq 1 }
        it { expect(Notifiable::NotificationStatus.first.opened?).to eq false }
        it { expect(Notifiable::Notification.first.opened_count).to eq 0 }
      end
    end
    
    describe "anonymously" do
      let(:notifiable_app) { create(:app) }
      let(:token) { create(:mock_token, :app => notifiable_app) }
      let(:localized_notification) { create(:localized_notification, :locale => :en) }
      let!(:status) { create(:notification_status, :localized_notification => localized_notification, :device_token => token) }
      
      before(:each) { put :opened, {:localized_notification_id => localized_notification.id, :device_token_id => token.id} }
      
      it { expect(Notifiable::NotificationStatus.count).to eq 1 }
      it { expect(Notifiable::NotificationStatus.first.opened?).to eq true }
      it { expect(Notifiable::Notification.first.opened_count).to eq 1 }      
    end
    
    
  end
  
end