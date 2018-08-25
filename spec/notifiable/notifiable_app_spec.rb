# frozen_string_literal: true

require 'spec_helper'

describe Notifiable::App do
  describe '#name' do
    context 'missing' do
      subject { build(:app, name: nil) }

      it { is_expected.to_not be_valid }
    end

    context 'blank' do
      subject { build(:app, name: '') }

      it { is_expected.to_not be_valid }
    end
  end

  describe '#notifications' do
    subject(:notifiable_app) { create(:app) }

    let!(:notification) { create(:notification, app: notifiable_app) }

    it { expect(notification.app).to_not be_nil }
    it { expect(notifiable_app.notifications.count).to eq 1 }
  end

  describe '#configure' do
    subject(:notifiable_app) { create(:app, configuration: { configurable_mock: { use_sandbox: true } }) }

    let(:notification) { create(:notification, app: notifiable_app) }
    let(:notifier) { ConfigurableMockNotifier.new(notification) }

    before(:each) { notifiable_app.configure :configurable_mock, notifier }

    it { expect(notifier.use_sandbox).to eq true }
  end

  describe '#configuration' do
    subject(:notifiable_app) { create(:app) }

    let(:notification) { create(:notification, app: notifiable_app) }
    let(:notifier) { ConfigurableMockNotifier.new(notification) }

    it { expect(notifiable_app.send(:configuration)).to eq mock: {}, configurable_mock: { use_sandbox: nil } }
  end

  describe 'define_configuration_accessors' do
    it { expect(Notifiable::App.instance_methods).to include(:configurable_mock_use_sandbox) }
    it { expect(Notifiable::App.instance_methods).to include(:configurable_mock_use_sandbox=) }
  end
end
