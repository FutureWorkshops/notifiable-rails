
module FwtPushNotificationServer
  
  class DeviceTokensController < FwtPushNotificationServer.api_controller_class

    skip_authorization_check

    def create
      @device_token = DeviceToken.find_or_create_by_token(params[:token])
      @device_token.update_attributes({
        :user_id => params[:user_id],
        :provider => params[:provider]
      })

      user = @device_token.user
      user.update_attributes(user_info_params) unless user_info_params.nil? && user.nil?

      if @device_token.save
        render :json => { :status => 0 }
      else
        render :json => { :errors => @device_token.errors.full_messages }
      end
    end

    private
      def device_token_params
        params.permit(:token, :user_id, :provider)
      end

      def user_info_params
        unless params[:user].nil? || FwtPushNotificationServer.permitted_user_attributes.nil?
          params[:user].permit(FwtPushNotificationServer.permitted_user_attributes)
        else
          nil
        end
      end

  end
  
end
