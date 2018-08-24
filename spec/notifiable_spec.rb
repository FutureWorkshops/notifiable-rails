require 'spec_helper'

describe Notifiable do
  
  describe '.notifier_class' do
    context 'no override' do
      let(:notification) { create(:notification) }
      let(:device) { create(:device_token, provider: :mock) }
      before(:each) { Notifiable.notifier_classes[:mock] = MockNotifier }
      it { expect(Notifiable.notifier_class(notification, device)).to eq MockNotifier }
    end
    
    context 'override' do
      let(:notification) { create(:notification) }
      let(:device) { create(:device_token, provider: :mock) }
      before(:each) do 
        Notifiable.notifier_classes[:mock] = MockNotifier
        Notifiable.find_notifier_class do |notification, device|
          ConfigurableMockNotifier
        end
      end
      it { expect(Notifiable.notifier_class(notification, device)).to eq MockNotifier }
    end
  end
  
end