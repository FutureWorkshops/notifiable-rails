require 'spec_helper'

describe Notifiable::Notification do
  
  it "stores a message" do    
    Notifiable::Notification.create(:message => "Test message")
    
    Notifiable::Notification.first.message.should eql "Test message"
  end
  
  it "stores params" do    
    Notifiable::Notification.create :params => {:custom_property => "A different message"}
    
    Notifiable::Notification.first.params.should == {:custom_property => "A different message"}
  end
  
  it "destroys dependent NotificationStatuses" do
    n = Notifiable::Notification.create :params => {:custom_property => "A different message"}
    Notifiable::NotificationStatus.create :notification => n
    
    n.destroy
    
    Notifiable::NotificationStatus.count.should == 0
  end
  
end