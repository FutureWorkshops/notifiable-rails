
module FwtPushNotificationServer
  
  class DeviceTokensController < FwtPushNotificationServer.api_controller_class

    skip_authorization_check

    def create
      @device_token = DeviceToken.find_or_create_by_token(params[:token])
      @device_token.update_attributes({
        :user_id => params[:user_id],
        :provider => params[:provider]
      })
      if @device_token.present?
        @device_token.save
        status = 0
      else
        status = -1
      end
      render :json => { :status => status }
    end

    private
      def device_token_params
        params.permit(:token, :user_id, :provider)
      end

  end
  
end
