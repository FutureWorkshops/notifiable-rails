Notifiable.configure do |config|

  # The controller class that the DeviceTokenController should extend
	config.api_controller_class = ApplicationController
  
  # Set the params permitted for creation of device tokens
  # Defaults to [:token, :provider, :app_id]
  #config.api_device_token_params = [:token, :provider, :app_id]
  
  # The class representing the holder of the device
	config.user_class = User
  
  # The size of the batch of Notification Statuses kept in memory
  # before being saved. This should be varied with the heap size of the process
  # sending the notifications. Defaults to 10,000.
  #config.notification_status_batch_size = 10000
  
  # Set the delivery method to test, preventing notifications from being sent
  # Defaults to :send
  #config.delivery_method = :test

end