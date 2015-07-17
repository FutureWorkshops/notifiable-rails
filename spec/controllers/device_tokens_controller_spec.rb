require 'spec_helper'

describe Notifiable::DeviceTokensController do
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
    @request.env["CONTENT_TYPE"] = "application/json"
  end
  
  describe "#create" do
    context "for existing user" do
      let(:user1) { create(:user) }
      let(:app) { create(:app) }
      
      before(:each) { post :create, :token => "ABC123", :user_email => user1.email, :provider => :apns, :app_id => app.id }
      
      it { expect(response.status).to eq 200 }
      it { expect(json['id']).to_not be_nil }
      it { expect(Notifiable::DeviceToken.count).to eq 1 }
      it { expect(Notifiable::DeviceToken.first.token).to eq "ABC123" }
      it { expect(Notifiable::DeviceToken.first.provider).to eq "apns" }
      it { expect(Notifiable::DeviceToken.first.app).to eq app }
      it { expect(User.first.device_tokens.count).to eq 1 }      
    end
    
    context "anonymously" do
      let(:app) { create(:app) }
      
      before(:each) { post :create, :token => "ABC123", :provider => :apns, :app_id => app.id }
      
      it { expect(response.status).to eq 200 }
      it { expect(json['id']).to_not be_nil }
      it { expect(Notifiable::DeviceToken.count).to eq 1 }
      it { expect(Notifiable::DeviceToken.first.token).to eq "ABC123" }
      it { expect(Notifiable::DeviceToken.first.provider).to eq "apns" }
      it { expect(Notifiable::DeviceToken.first.app).to eq app }
    end
    
    context "for an existing valid token" do
      let(:app) { create(:app) }
      let!(:token) { create(:mock_token, :token => "DEF456", :provider => :apns, :app => app) }
      
      before(:each) { post :create, :token => "DEF456", :provider => :apns, :app_id => app.id }
      
      it { expect(response.status).to eq 200 }
      it { expect(json['id']).to eq token.id }
      it { expect(Notifiable::DeviceToken.count).to eq 1 }
      it { expect(Notifiable::DeviceToken.first.token).to eq "DEF456" }
      it { expect(Notifiable::DeviceToken.first.provider).to eq "apns" }
      it { expect(Notifiable::DeviceToken.first.app).to eq app }
    end
    
    context "for an existing invalid token" do
      let(:app) { create(:app) }
      let!(:token) { create(:mock_token, :token => "DEF456", :provider => :apns, :app => app, :is_valid => false) }
      
      before(:each) { post :create, :token => "DEF456", :provider => :apns, :app_id => app.id }
      
      it { expect(response.status).to eq 200 }
      it { expect(json['id']).to eq token.id }
      it { expect(Notifiable::DeviceToken.count).to eq 1 }
      it { expect(Notifiable::DeviceToken.first.token).to eq "DEF456" }
      it { expect(Notifiable::DeviceToken.first.provider).to eq "apns" }
      it { expect(Notifiable::DeviceToken.first.app).to eq app }
      it { expect(Notifiable::DeviceToken.first.is_valid).to eq true }
    end
    
    context "unless an App is specified" do      
      before(:each) { post :create, :token => "ABC123", :provider => :apns }
      
      it { expect(response.status).to eq 422 }
      it { expect(Notifiable::DeviceToken.count).to eq 0 }
    end
    
  end
  
  context "old" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user_with_en_token) }
    let(:user2_device_token) { user2.device_tokens.first }
    let(:app) { FactoryGirl.create(:app) }
    let(:invalid_device_token) { FactoryGirl.create(:invalid_mock_token) }

    it "anonymises an existing token" do
    
      post :create, :token => user2_device_token.token, :provider => :mpns
    
    	response.status.should == 200
      Notifiable.api_device_token_params.push('id').each{|p| json.should have_key(p.to_s)} 
    
    	Notifiable::DeviceToken.count.should == 1
      dt = Notifiable::DeviceToken.first
      dt.token.should eql user2_device_token.token
      dt.user.should be_nil
    end
  
    it "updates token for an existing device token" do
      put :update, :id => user2_device_token.id, :token => "DEF456", :user_email => user2.email

    	response.status.should == 200
      Notifiable.api_device_token_params.each{|p| json.should have_key(p.to_s)} 
    
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
    
    	response.status.should == 401 
    
    	Notifiable::DeviceToken.where(:token => user2_device_token.token).count.should == 1
    end
  
    it "doesn't delete tokens of other users" do
    	delete :destroy, :id => user2_device_token.id, :user_email => user1.email
    
    	response.status.should == 401
    
    	Notifiable::DeviceToken.where(:token => user2_device_token.token).count.should == 1
    end
  
    it "doesnt delete tokens if they don't exist" do
    	delete :destroy, :id => 59, :user_email => user1.email
    
    	response.status.should == 404
    	Notifiable::DeviceToken.where(:token => user2_device_token.token).count.should == 1
    end
  
    it "doesn't update token unless authorised" do 
      put :update, :id => user2_device_token.id, :user_email => user1.email, :token => "ZXY987"
        
      response.status.should == 401
      user2_device_token.token.should.eql? "ZXY987"
    end
    
  end
  
end