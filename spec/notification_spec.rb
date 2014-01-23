require 'spec_helper'

describe Notifiable::Notification do

  let(:n) { FactoryGirl.create :localized_notification }

  it "stores messages in different locales" do   
    n
     
    db_t = Notifiable::Notification.first
        
    db_t.message(:ar).should eql "رسالة"
    db_t.message(:en).should eql "Test Message"
  end
  
  it "provides a localised provider message" do    
    u = FactoryGirl.create :user_with_mock_token
        
    n.localized_provider_message(u.device_tokens.first).should eql "Test Message"
  end
  
  it "provides an Arabic provider message" do    
    u = FactoryGirl.create(:user_with_mock_token, :locale => :ar)    
    n.localized_provider_message(u.device_tokens.first).should eql "رسالة"
  end
  
end