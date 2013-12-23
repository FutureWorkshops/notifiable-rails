# Notifiable

<b>Notifiable</b> is a Rails engine which handles sending push notifications and  device registrations.

Currently supported platforms:

-  **APNS** (Apple Push Notification Service)
-  **GCM** (Google Cloud Messaging)
 
 
Only text alerts are supported at this time. 
 

## USAGE

### Registering device token

Registering a new device token is done by POSTing to <b>/device_tokens</b> endpoint.

Supported fields:

- <b>token</b> - device token retrieved from APNS or GCM
- <b>user_id</b> - unique key of user whose device is being registered. This field is used to connect <i>DeviceToken</i> objects to users.
- <b>provider</b> - either <i>apns</i> or <i>gcm</i>

Sample request:
```javascript
// POST /device_tokens
// Content-Type: application/json
{
    "token" : "SADFD234GFSD7982321321",
    "user_id" : "user@example.com",
    "provider" : "apns"
}
```
Response:
```javascript
{
	"status" : 0
}
// 0 means successful registration, -1 indicates an error.
```

#### Inactive device tokens

Invalid and inactive token registrations are handled automatically based on feedback from APNS and GCM.
It is however important to note that mixing sandbox and production APNS tokens is not currently supported.

#### iOS integration

Integration on iOS is handled via <a href="https://github.com/FutureWorkshops/FWTPushNotifications">FWTPushNotifications</a> cocoapod.


### Notifying single user

```ruby
	u = User.find_by_email("kamil@futureworkshops.com")
	u.notify_once("Hi there!")
```
Push notifications will be sent to all active devices of the user using appropriate providers.

### Notifying multiple users

```ruby
	alert = "Hi all!"
    users = User.all
	Notifiable.begin_transaction(alert) do
        user.each do |u|
        	u.schedule_notification
        end
    end
```
This transactional method minimises the amount of connections. This is preferred way of sending large amounts of notifications.

### Manually sending a notification

```ruby
	u = User.first
    tokens = u.device_tokens
    notifier = Notifiable.notifiers[:gcm]
    notifier.notify_once("Hi!", tokens)

```

## INSTALLATION

1. Add the gem to your bundle
```ruby 
gem 'fwt_push_notification_server'
```

2. Mount engine routes in <i>routes.rb</i>
```ruby
mount Notifiable::Engine => "/"
```
3. Run the install generator
```ruby
rails g fwt_push_notification_server:install
```

4. Make your devise users <b>notifiable</b>.<br/>
Add <i>:notifiable</i> concern to your user model and in <i>config/initializers/devise.rb</i>:
```ruby
require 'devise/models/notifiable'
```

5. Customise settings in <i>config/initializers/fwt_push_notification_server.rb</i>.

6. Migrate your database
```ruby
rake db:migrate
```

## CONFIGURATION

The module is configured in <i>config/initializers/fwt_push_notification_server.rb</i>.

```ruby
Notifiable.configure do |config|

	# APNS
	config.apns_certificate = File.join(Rails.root, 'config', 'apns-development.pem')
	config.apns_passphrase = 'PEM_PASSPHRASE'
	config.apns_gateway = 'gateway.sandbox.push.apple.com' # gateway.push.apple.com for production
	
	# GCM
	config.gcm_api_key = 'YOUR-GCM-API-KEY-HERE'

	# Devise integration
	config.api_controller_class = ApplicationController # base controller class to use for token registrations
	config.authentication_filter = :authenticate_user! # before_filter to use for authentication
	config.user_class = User
	config.user_key = :user_id # foreign key name to join tokens with users during token registration from mobile client

end
```

## LICENSE

Apache License Version 2.0