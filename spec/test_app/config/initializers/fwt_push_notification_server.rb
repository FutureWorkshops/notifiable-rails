
FwtPushNotificationServer.configure do |config|

	# APNS
	config.apns_certificate = File.join(Rails.root, 'config', 'APNSDevelopment.pem')
	config.apns_passphrase = 'PASSPHRASE'
	config.apns_gateway = 'gateway.sandbox.push.apple.com'
	
	# GCM
	config.gcm_api_key = 'YOUR-KEY-HERE'

	# Devise integration
	config.api_controller_class = ApplicationController
	config.user_class = User
	config.user_key = :email
	config.permitted_user_attributes = :first_name, :last_name

end