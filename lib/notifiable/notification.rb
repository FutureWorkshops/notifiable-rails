module Notifiable
  class Notification < ActiveRecord::Base
    def apns_message
      @apns_message ||= (self.message.bytesize > 232 ? "#{self.message.byteslice(0, 229)}..." : self.message)
    end
  end
end