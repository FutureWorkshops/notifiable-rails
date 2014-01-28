
module Notifiable
  
  class DeviceTokensController < Notifiable.api_controller_class
    
    before_filter :ensure_current_notifiable_user, :only => :destroy
    
    def create
      if params[:device_id]
        @device_token = DeviceToken.find_or_create_by(:device_id => params[:device_id])
        @device_token.token = params[:token]                
      else
        @device_token = DeviceToken.find_or_create_by(:token => params[:token]) 
      end
      
      @device_token.provider = params[:provider]
      @device_token.user_id = current_notifiable_user.id if current_notifiable_user

      if @device_token.save
        head :status => :ok
      else
        render :json => { :errors => @device_token.errors.full_messages }, :status => :internal_server_error
      end
    end

    def destroy
      @device_token = DeviceToken.where(:token => params[:token]).first
      if !@device_token
        head :status => :not_found        
      elsif !@device_token.user.eql?(current_notifiable_user)
        head :status => :unauthorized
      elsif @device_token.destroy
        head :status => :ok
      else
        render :json => { :errors => @device_token.errors.full_messages }, :status => :internal_server_error
      end
    end
    
    private
    def ensure_current_notifiable_user
      head :status => :not_acceptable unless current_notifiable_user
    end
  end
  
end
