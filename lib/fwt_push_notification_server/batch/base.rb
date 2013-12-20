module FwtPushNotificationServer
  module Batch
    class Base
      attr_accessor :notifiers
    
      def initialize(options)
        @notifiers = {
          :apns => Notifier::APNS.new,
          :gcm => Notifier::GCM.new
        }
      end
  
      def self.begin(options = {})
        b = self.new(options)
        yield(b)
        b.send_notifications
      end
    end
  end
end