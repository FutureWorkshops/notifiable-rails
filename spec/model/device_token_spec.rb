require 'spec_helper'

describe Notifiable::DeviceToken do
  
  describe "#locale" do
    subject(:token) { create(:mock_token, :locale => 'en') }
    
    it { expect(token.locale).to eq 'en' }
  end
  
  describe "#notification_statuses" do
    subject(:token) { create(:mock_token, :notification_statuses => create_list(:notification_status, 2)) }
    
    it { expect(token.notification_statuses.count).to eq 2 }
  end
end