
module Notifiable
  
  class DeviceTokensController < Notifiable.api_controller_class
    
    rescue_from ActiveRecord::RecordNotFound do |error|
      render :json => {:error => error.message}, :status => :not_found
    end
    
    before_filter :find_device_token, :ensure_current_notifiable_user!, :ensure_authorized!, :only => [:update, :destroy]
    
    def create
      @device_token = DeviceToken.find_by(:token => params[:token]) 
      @device_token = DeviceToken.new unless @device_token

      perform_update
    end
    
    def update
      perform_update
    end

    def destroy    
      if @device_token.destroy
        head :status => :ok
      else
        render :json => { :errors => @device_token.errors.full_messages }, :status => :unprocessable_entity
      end
    end
    
    private
      def perform_update
        if @device_token.update_attributes(device_token_params)
          render :json => @device_token, :status => :ok
        else
          render :json => { :errors => @device_token.errors.full_messages }, :status => :unprocessable_entity
        end
      end
    
      def device_token_params
        device_token_params = params.permit(Notifiable.api_device_token_params)
        device_token_params[:user_id] = current_notifiable_user.id if current_notifiable_user && !device_token_params.has_key?(:user_id)
        device_token_params
      end
    
      def ensure_current_notifiable_user!
        head :status => :not_acceptable unless current_notifiable_user
      end
    
      def ensure_authorized!
        head :status => :unauthorized if @device_token.user && !@device_token.user.eql?(current_notifiable_user)
      end
    
      def find_device_token
        @device_token = DeviceToken.find(params[:id])
      end
  end
  
end
