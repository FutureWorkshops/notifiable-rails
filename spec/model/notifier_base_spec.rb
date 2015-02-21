require 'spec_helper'

describe Notifiable::NotifierBase do

  describe "#test_env?" do
    let(:notifiable_app) { FactoryGirl.create(:app, :configuration => {:configurable_mock => {:use_sandbox => true}}) }
    let(:notification) { FactoryGirl.create(:notification, :app => notifiable_app) }
    subject(:notifier) { ConfigurableMockNotifier.new(Rails.env, notification) }
    
    before(:each) { ConfigurableMockNotifier.send(:public, *ConfigurableMockNotifier.protected_instance_methods) }  

    it { expect(notifier.test_env?).to eq true }
  end
end

class ConfigurableMockNotifier < Notifiable::NotifierBase
  attr_accessor :use_sandbox
end