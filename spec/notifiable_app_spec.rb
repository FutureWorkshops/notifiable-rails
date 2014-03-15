require 'spec_helper'

describe Notifiable::App do

  let(:notifiable_app) { FactoryGirl.create(:app) }
  let(:notification) { FactoryGirl.create(:notification, :app => notifiable_app) }
  
  it "contains notifications" do  
    notification.app.should_not be_nil
    notifiable_app.notifications.count.should == 1
  end
  
end
