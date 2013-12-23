module Notifiable
  class Notification
    attr_accessor :message
    attr_accessor :payload
    
    def initialize(options = {})
      options.each {|k,v| instance_variable_set("@#{k}",v)}
    end
    
    def apns_message
      @apns_message ||= (@message.bytesize > 232 ? "#{@message.byteslice(0, 229)}..." : @message)
    end
  end
end