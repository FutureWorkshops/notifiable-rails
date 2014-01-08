# Notifiable

<b>Notifiable</b> is a Rails engine which handles sending push notifications and device registrations.

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
// 0 means successful registration, otherwise an error will be returned
```

#### Inactive device tokens

Invalid and inactive token registrations are handled automatically based on feedback from APNS and GCM.
It is however important to note that mixing sandbox and production APNS tokens is not currently supported.

### Releasing device token

To release device token from the user (e.g. after logout), the following request needs to be made:
```javascript
DELETE /device_tokens/:token
```

### iOS integration

Integration on iOS is handled via <a href="https://github.com/FutureWorkshops/Notifiable-iOS">Notifiable-iOS</a> cocoapod.

### Notifying a single user

```ruby
    n = Notifiable::Notification.create(:message => 'Hi there!')
    u = User.find_by_email("kamil@futureworkshops.com")
    u.send_notification(n)
```
Push notifications will be sent to all active devices of the user using appropriate providers.

### Notifying multiple users

```ruby
    n = Notifiable::Notification.create(:message => 'Hi all!')
    users = User.all
    Notifiable.batch do |batch|
        users.each do |u|
            batch.add(n, u)    
        end
    end
```
This transactional method minimises the amount of connections. This is preferred way of sending large amounts of notifications.


### Security

To prevent token forgery base controller class for Notifiable is expected to handle authentication and implement ```can_update?(user_id) -> true or false``` method.


Example implementation allowing only modifications of tokens belonging to currently authenticaticated user:

```ruby
def can_update?(user_id)
    current_user && current_user.email == user_id
end
```

## INSTALLATION

1. Add the gem to your bundle
```ruby 
gem 'notifiable'
```

1. Require notifiable in <i>application.rb</i>
```
require 'notifiable'
```

1. Mount engine routes in <i>routes.rb</i>
```ruby
mount Notifiable::Engine => "/"
```

1. Run the install generator
```ruby
rails g notifiable:install
```

1. Customise settings in <i>config/initializers/notifiable.rb</i>.

## LICENSE

Apache License Version 2.0