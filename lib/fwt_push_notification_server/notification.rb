class FwtPushNotificationServer::Notification
  attr_accessor :message
  attr_accessor :device_tokens
  @device_tokens = []
  
  def add_device_token(device_token)
    @device_tokens << device_token
  end
end