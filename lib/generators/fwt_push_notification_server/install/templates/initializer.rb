
FwtPushNotificationServer.configure do |config|

	# APNS
	config.apns_certificate = File.join(Rails.root, 'config', 'APNSDevelopment.pem')
	config.apns_passphrase = 'PASSPHRASE'
	config.apns_gateway = 'gateway.sandbox.push.apple.com'
	
	# Devise integration
	config.api_controller_class = ApplicationController
	config.authentication_filter = :authenticate_user!
	config.user_class = User
	config.user_key = :user_id

end