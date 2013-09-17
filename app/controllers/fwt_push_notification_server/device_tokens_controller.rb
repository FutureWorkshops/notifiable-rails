require_dependency "fwt_push_notification_server/application_controller"
require 'digest'

module FwtPushNotificationServer
  
  class DeviceTokensController < ApplicationController

    skip_before_filter :authenticate_user!, :if => lambda {
      if params[:token].blank? || params[:sig].blank?
        false
      else
        token = params[:token]
        config = FwtPushNotificationServer.config
        key = config[:api_key]
        puts key
        !!(Digest::HMAC.hexdigest(token, key, Digest::SHA256) == params[:sig])
      end
    }

    # GET /device_tokens
    def index
      @device_tokens = DeviceToken.page.per(100)
    end

    # POST /device_tokens
    def create
      @device_token = DeviceToken.new({
        :token => params[:token],
        :device_id => params[:device_id],
        :device_name => params[:device_name]
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
      # Only allow a trusted parameter "white list" through.
      def device_token_params
        params.permit(:token, :device_id, :device_name, :is_valid, :key, :sig)
      end

  end
  
end
