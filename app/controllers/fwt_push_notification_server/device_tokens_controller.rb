require_dependency "fwt_push_notification_server/application_controller"

module FwtPushNotificationServer
  
  class DeviceTokensController < ApplicationController

    skip_before_filter :authenticate_user!, :if => lambda {
      if params[:token].blank? || params[:sig].blank?
        false
      else
        token = params[:token]
        key = ApplicationConfig.api_key
        !!(Digest::HMAC.hexdigest(token, key, Digest::SHA256) == params[:sig])
      end
    }

    # GET /device_tokens
    def index
      @device_tokens = DeviceToken.page.per(100)
    end

    # POST /device_tokens
    def create
      @device_token = DeviceToken.new(device_token_params)

      if @device_token.save
        redirect_to @device_token, notice: 'Device token was successfully created.'
      else
        render action: 'new'
      end
    end

    private
      # Only allow a trusted parameter "white list" through.
      def device_token_params
        params.require(:device_token).permit(:token, :device_id, :device_name, :is_valid)
      end

  end
  
end
