require "fwt_push_notification_server/engine"
require 'notifier/base'
require 'notifier/apns'
require 'notifier/gcm'

module FwtPushNotificationServer

  mattr_accessor :api_controller_class

  mattr_accessor :user_class

  mattr_accessor :permitted_user_attributes

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

  mattr_accessor :notifiers
  @@notifiers = {
    :apns => Notifier::APNS.new,
    :gcm => Notifier::GCM.new
  }

  def self.apns_config
    {
      :gateway => apns_gateway,
      :certificate => apns_certificate,
      :passphrase => apns_passphrase
    }
  end

  def self.begin_transaction(message, payload = nil)
    notifiers.each_value do |notifier|
      notifier.begin_transaction(message, payload)
    end
    yield
    notifiers.each_value do |notifier|
      notifier.commit_transaction
    end
  end

end
