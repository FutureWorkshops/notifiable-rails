require 'spec_helper'

describe Notifiable::DeviceTokensController do
  
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user_with_mock_token) }
  let(:user2_device_token) { user2.device_tokens.first }
  let(:app) { FactoryGirl.create(:app) }
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
    @request.env["CONTENT_TYPE"] = "application/json"
  end

  it "creates a new device token for an existing user" do
    post :create, :token => "ABC123", :user_email => user1.email, :provider => :apns, :app_id => app.id
    
    expect(response).to be_success
    
    Notifiable::DeviceToken.count.should == 1
    user1.device_tokens.count.should == 1
    dt = user1.device_tokens.first
    dt.token.should.eql? "ABC123"
    dt.provider.should.eql? :apns 
    dt.app.should.eql? app   
  end
  
  it "creates a new device token for an anonymous user" do
    post :create, :token => "ABC123", :provider => :apns, :app_id => app.id
    
    expect(response).to be_success
    
    Notifiable::DeviceToken.count.should == 1
    dt = Notifiable::DeviceToken.first
    dt.token.should.eql? "ABC123"
    dt.provider.should.eql? :apns   
    dt.app.should.eql? app
    User.count.should == 0 
  end
  
  it "uses an existing token" do
    post :create, :token => user2_device_token.token, :provider => user2_device_token.provider, :app_id => app.id, :user_email => user2.email
    
    expect(response).to be_success
    
    Notifiable::DeviceToken.count.should == 1
    user2.device_tokens.count.should == 1
    dt = Notifiable::DeviceToken.first
    dt.token.should eql user2_device_token.token
    dt.provider.should eql user2_device_token.provider
    dt.app.should.eql? app
  end
  
  it "doesn't create a token if no app is specified" do
    post :create, :token => "ABC123", :user_email => user1.email, :provider => :mpns
    
  	expect(response.status).to eq(422)
  	Notifiable::DeviceToken.count.should == 0
  end
  
  it "anonymises an existing token" do
    
    post :create, :token => user2_device_token.token, :provider => :mpns
    
  	expect(response.status).to eq(200)
  	Notifiable::DeviceToken.count.should == 1
    dt = Notifiable::DeviceToken.first
    dt.token.should eql user2_device_token.token
    dt.user.should be_nil
  end
  
  it "updates token for an existing device token" do
    put :update, :id => user2_device_token.id, :token => "DEF456", :user_email => user2.email

  	expect(response.status).to eq(200)
    
  	Notifiable::DeviceToken.count.should == 1
    dt = Notifiable::DeviceToken.first
    dt.token.should eql "DEF456"
  end

  it "deletes tokens" do
    delete :destroy, :id => user2_device_token.id, :user_email => user2.email
    
    expect(response).to be_success
    Notifiable::DeviceToken.count.should == 0
  end

  it "doesn't delete token unless authorised" do
  	delete :destroy, :id => user2_device_token.id
    
  	expect(response.status).to eq(401)
  	Notifiable::DeviceToken.where(:token => user2_device_token.token).count.should == 1
  end
  
  it "doesn't delete tokens of other users" do
  	delete :destroy, :id => user2_device_token.id, :user_email => user1.email
    
  	expect(response.status).to eq(401)
  	Notifiable::DeviceToken.where(:token => user2_device_token.token).count.should == 1
  end
  
  it "doesnt delete tokens if they don't exist" do
  	delete :destroy, :id => 59, :user_email => user1.email
    
  	expect(response.status).to eq(404)
  	Notifiable::DeviceToken.where(:token => user2_device_token.token).count.should == 1
  end
  
end