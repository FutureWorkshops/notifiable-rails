Notifiable.configure do |config|

  #
	# Rails Engine
  #
  
  # The controller class that the DeviceTokenController should extend
	config.api_controller_class = ApplicationController
  
  # The class representing the holder of the device
	config.user_class = User

  #
	# APNS
  #
  
  # The name of the Notifier::Base subclass used for this notifier 
  config.apns_class_name = 'Notifiable::Notifier::APNS::GrocerStream'
  
  # The path to your apns private key
	config.apns_certificate = File.join(Rails.root, 'config', 'apns-production.pem')
  
  # The passphrase for your private key
  # Defaults to nil
	#config.apns_passphrase = 'YOUR-PASSPHRASE-HERE'
	
  # The apns gateway to use
  # Defaults to 'gateway.push.apple.com', can also be 'gateway.sandbox.push.apple.com'
  #config.apns_gateway = 'gateway.push.apple.com'
	
  #
	# GCM
  #
  
  # The name of the Notifier::Base subclass used for this notifier 
  config.gcm_class_name = 'Notifiable::Notifier::GCM::GCMBatch'
  
  # Your GCM API Key
	#config.gcm_api_key = 'YOUR-KEY-HERE'
  
  # The batch size
  # Defaults to 1000
  #config.gcm_batch_size = 1000
  
  #
  # Global
  #
  
  # Set the delivery method to test, preventing notifications from being sent
  # Defaults to :send
  #config.delivery_method = :test

end