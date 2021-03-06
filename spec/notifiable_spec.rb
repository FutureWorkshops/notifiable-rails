# frozen_string_literal: true

require 'spec_helper'

describe Notifiable do
  describe '.notifier_class' do
    context 'no override' do
      let(:notification) { create(:notification)                  }
      let(:device)       { create(:device_token, provider: :mock) }

      before(:each) do
        Notifiable.find_notifier_class_proc = nil
        Notifiable.notifier_classes[:mock] = MockNotifier
      end

      it { expect(Notifiable.notifier_class(notification, device)).to eq MockNotifier }
    end

    context 'override' do
      let(:notification) { create(:notification) }
      let(:device) { create(:device_token, provider: :mock) }

      before(:each) do
        Notifiable.notifier_classes[:mock] = MockNotifier
        Notifiable.find_notifier_class_proc = proc do |_notification, _device|
          ConfigurableMockNotifier
        end
      end

      it { expect(Notifiable.notifier_class(notification, device)).to eq ConfigurableMockNotifier }
    end
  end
end
