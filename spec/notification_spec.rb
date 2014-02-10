require 'spec_helper'

describe Notifiable::Notification do
  
  it "stores a message" do    
    Notifiable::Notification.create :message => "Test message"
    
    Notifiable::Notification.first.provider_value(:mock, :message).should eql "Test message"
  end
  
  it "overrides a message" do    
    Notifiable::Notification.create :message => "Test message", :payload => {:mock => {:message => "A different message"}}
    
    Notifiable::Notification.first.provider_value(:mock, :message).should eql "A different message"
  end
  
  it "returns a hash" do    
    Notifiable::Notification.create :payload => {:mock => {:custom => {:custom_property => "A different message"}}}
    
    Notifiable::Notification.first.provider_value(:mock, :custom).should == {:custom_property => "A different message"}
  end
  
  it "returns nil for a property that doesnt exist" do    
    Notifiable::Notification.create :message => "Test message"
    
    Notifiable::Notification.first.provider_value(:mock, :sound).should be_nil
  end
  
end