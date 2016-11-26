FactoryGirl.define do

  sequence(:token) {|n| "ABCD#{n}" }

  factory :device_token, aliases: [:mock_token], :class => Notifiable::DeviceToken do
    provider :mock
    token
    app
    
    factory :invalid_mock_token do
      is_valid false
    end
  end
  
  factory :app, :class => Notifiable::App do
    sequence(:name) {|n| "App #{n}" }
  end
  
  factory :notification, :class => Notifiable::Notification do
    app
  end
  
  factory :notification_status, :class => Notifiable::NotificationStatus do
    notification
    status 0
    device_token
  end  
end