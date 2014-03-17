Notifiable.configure do |config|

  # The controller class that the DeviceTokenController should extend
	config.api_controller_class = ApplicationController
  
  # Set the params permitted for creation of device tokens
  # Defaults to [:device_id, :token, :provider]
  #config.api_device_token_params = [:device_id, :token, :provider]
  
  # The class representing the holder of the device
	config.user_class = User
  
  # Set the delivery method to test, preventing notifications from being sent
  # Defaults to :send
  #config.delivery_method = :test

end