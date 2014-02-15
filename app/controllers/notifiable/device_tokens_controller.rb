
module Notifiable
  
  class DeviceTokensController < Notifiable.api_controller_class
    
    before_filter :ensure_current_notifiable_user, :only => :destroy
    
    def create
      if params[:device_id]
        @device_token = DeviceToken.find_by(:device_id => params[:device_id])
      else
        @device_token = DeviceToken.find_by(:token => params[:token]) 
      end      
      @device_token = DeviceToken.new unless @device_token

      notifiable_params = params.permit(Notifiable.api_device_token_params)
      notifiable_params[:user_id] = current_notifiable_user.id if current_notifiable_user

      if @device_token.update_attributes(notifiable_params)
        head :status => :ok
      else
        render :json => { :errors => @device_token.errors.full_messages }, :status => :unprocessable_entity
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
        render :json => { :errors => @device_token.errors.full_messages }, :status => :unprocessable_entity
      end
    end
    
    private
    def ensure_current_notifiable_user
      head :status => :not_acceptable unless current_notifiable_user
    end
  end
  
end
