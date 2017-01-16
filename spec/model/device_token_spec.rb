require 'spec_helper'

describe Notifiable::DeviceToken do
  
  describe "#locale" do
    subject(:token) { create(:device_token, locale: 'en') }
    
    it { expect(token.locale).to eq 'en' }
  end
  
  describe "#name" do
    subject(:token) { create(:device_token, name: "Matt's iPhone") }
    
    it { expect(token.name).to eq "Matt's iPhone" }
  end
  
  describe "#lonlat" do
    subject(:token) { create(:device_token, lonlat: 'POINT(-122 47)') }
    
    it { expect(token.lonlat.lat).to eq 47 }
    it { expect(token.lonlat.lon).to eq -122 }
  end
  
  describe ".nearby" do
    subject!(:token) { create(:device_token, lonlat: 'POINT(-122 47)') }
    
    it { expect(Notifiable::DeviceToken.nearby(-122, 47, 500).count).to eq 1 }
  end
  
  describe "#notification_statuses" do
    subject(:token) { create(:device_token, :notification_statuses => create_list(:notification_status, 2)) }
    
    it { expect(token.notification_statuses.count).to eq 2 }
  end
  
  describe "#token" do
    context "missing" do
      subject { build(:device_token, token: nil) }
      it { is_expected.to_not be_valid }
    end
    
    context "blank" do
      subject { build(:device_token, token: "") }
      it { is_expected.to_not be_valid }
    end
    
    context "unique" do
      let(:app1) { create(:app) }
      subject { build(:device_token, token: "abc123", app: app1) }
      let!(:dt2) { create(:device_token, token: "abc123", app: app1) }
      it { is_expected.to_not be_valid }
    end
  end
end