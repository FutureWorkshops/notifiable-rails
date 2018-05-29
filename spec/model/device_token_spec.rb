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
  
  describe "#language" do
    context 'ISO 639-1' do
      subject(:token) { create(:device_token, language: 'en') }
      it { expect(token.language).to eq 'en' }
    end
    
    context 'ISO 639-2' do
      subject(:token) { create(:device_token, language: 'ido') }
      it { expect(token.language).to eq 'ido' }
    end
    
    context 'nil' do
      subject { create(:device_token, language: nil) }
      it { expect(subject.language).to be_nil }
    end
  end
  
  describe "#country" do    
    context 'ISO 3166-1' do
      subject { create(:device_token, country: 'GB') }
      it { expect(subject.country).to eq 'GB' }
    end
    
    context 'nil' do
      subject { create(:device_token, country: nil) }
      it { expect(subject.country).to be_nil }
    end
  end
end