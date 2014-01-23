# Notifiable Rails
<b>Notifiable-Rails</b> is a Rails engine which handles push notifications. It is:

- Stable
- Production Tested
- Performant
- Actively Maintained

### Features
Features include:

- A pluggable architecture in order to support new services
- Message localisation

### Services
Services supported by official plugins: 

| Service       | Server Plugin            | Client Plugin  | Throughput |
| ------------- |:------------------------:| --------------:| ----------:|
| APNS          | <a href="https://github.com/FutureWorkshops/notifiable-apns-grocer">notifiable-apns-grocer</a>   | <a href="https://github.com/FutureWorkshops/Notifiable-iOS">Notifiable-iOS</a> | 2000 p/s   |
| GCM           | <a href="https://github.com/FutureWorkshops/notifiable-gcm-spacialdb">notifiable-gcm-spacialdb</a> |                |            |
### Limitations

- Only text alerts are supported at this time. 

## USAGE

### Registering device tokens

Registering a new device token is done by POSTing to <b>/device_tokens</b> endpoint.

Supported fields:

- <b>token</b> - device token (i.e. the token retrieved from APNS or GCM)
- <b>provider</b> - lowercase service name (i.e. <i>apns</i> or <i>gcm</i>)

Sample request:
```javascript
// POST /device_tokens
// Content-Type: application/json
{
    "token" : "SADFD234GFSD7982321321",
    "provider" : "apns"
}
```

### Inactive device tokens

Invalid and inactive token registrations are handled automatically based on feedback from APNS and GCM.
It is however important to note that mixing sandbox and production APNS tokens is not currently supported.

### Releasing a device token

To release device token from the user (e.g. after logout), the following request needs to be made:
```javascript
DELETE /device_tokens/:token
```

### Notifying a single user

```ruby
    n = Notifiable::Notification.create
    n.set_localized_attribute(:message, :en, "Hi all!")
    n.set_localized_attribute(:message, :ar, "مرحبا جميع")
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

To prevent token forgery base controller class for Notifiable is expected to handle authentication provide the current user (if any) via the ```current_notifiable_user``` method.

Example implementation allowing only modifications of tokens belonging to currently authenticaticated user:

```ruby
def current_notifiable_user
    current_user
end
```

## INSTALLATION

1. Add the gem to your bundle
```ruby 
gem 'notifiable-rails'
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
