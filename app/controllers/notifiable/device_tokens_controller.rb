
module Notifiable
  
  class DeviceTokensController < Notifiable.api_controller_class
    
    rescue_from ActiveRecord::RecordNotFound do |error|
      render :json => {:error => error.message}, :status => :not_found
    end
    
    before_filter :find_device_token, :ensure_authorized!, :except => :create
    
    def create
      @device_token = DeviceToken.find_by(:token => params[:token]) 
      @device_token = DeviceToken.new unless @device_token

      if @device_token.update_attributes(device_token_params)
        render :json => { :id => @device_token.id }, :status => :ok
      else
        render :json => { :errors => @device_token.errors.full_messages }, :status => :unprocessable_entity
      end
    end
    
    def update
      if @device_token.update_attributes(device_token_params)
        head :status => :ok
      else
        render :json => { :errors => @device_token.errors.full_messages }, :status => :unprocessable_entity
      end
    end

    def destroy    
      if @device_token.destroy
        head :status => :ok
      else
        render :json => { :errors => @device_token.errors.full_messages }, :status => :unprocessable_entity
      end
    end
    
    private    
      def device_token_params
        device_token_params = params.permit(Notifiable.api_device_token_params)
        
        if current_notifiable_user
          device_token_params[:user_id] = current_notifiable_user.id 
        else
          device_token_params[:user_id] = nil   
        end
        
        device_token_params
      end
    
      def ensure_authorized!
        head :status => :unauthorized if @device_token.user && !@device_token.user.eql?(current_notifiable_user)
      end
    
      def find_device_token
        @device_token = DeviceToken.find(params[:id])
      end
  end
  
end
