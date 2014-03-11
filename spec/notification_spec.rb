require 'spec_helper'

describe Notifiable::Notification do
  
  it "stores a message" do    
    FactoryGirl.create(:notification, :message => "Test message")
    
    Notifiable::Notification.first.message.should eql "Test message"
  end
  
  it "stores params" do    
    FactoryGirl.create(:notification, :params => {:custom_property => "A different message"})
    
    Notifiable::Notification.first.params.should == {:custom_property => "A different message"}
  end
  
  it "destroys dependent NotificationStatuses" do
    n = FactoryGirl.create(:notification, :params => {:custom_property => "A different message"})
    Notifiable::NotificationStatus.create :notification => n
    
    n.destroy
    
    Notifiable::NotificationStatus.count.should == 0
  end
  
end