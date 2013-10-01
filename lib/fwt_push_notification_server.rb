require "fwt_push_notification_server/engine"
require 'notifier/apns'
require 'notifier/gcm'

module FwtPushNotificationServer

  mattr_accessor :api_controller_class

  mattr_accessor :authentication_filter
  @@authentication_filter = :authenticate_user!

  mattr_accessor :user_class

  mattr_accessor :user_key
  @@user_key = :user_id  

  mattr_accessor :apns_gateway
  @@apns_gateway = 'sandbox.push.apple.com'

  mattr_accessor :apns_certificate

  mattr_accessor :apns_passphrase


  mattr_accessor :gcm_api_key

  def self.configure
    yield self
  end

  ###
  # Push Notifications
  ###

  def self.apns_config
    {
      :gateway => apns_gateway,
      :certificate => apns_certificate,
      :passphrase => apns_passphrase
    }
  end

end
