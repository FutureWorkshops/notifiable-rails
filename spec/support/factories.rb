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
  end
  
  factory :notification, :class => Notifiable::Notification do
    app
    
    factory :notification_with_en_localization do
      after(:create) do |notification, evaluator|
        FactoryGirl.create(:localized_notification, :locale => :en, :notification => notification)
      end
    end
  end
  
  factory :localized_notification, :class => Notifiable::LocalizedNotification do
    notification
  end
  
  factory :notification_status, :class => Notifiable::NotificationStatus do
    localized_notification
    status 0
    device_token
  end
  
  sequence(:email) {|n| "person-#{n}@example.com" }
  
  factory :user do
    email
    
    factory :user_with_en_token do
      after(:create) do |user, evaluator|
        FactoryGirl.create(:device_token, :user_id => user.id, :locale => :en)
      end
    end
  
    factory :user_with_invalid_mock_token do
      after(:create) do |user, evaluator|
        FactoryGirl.create(:invalid_mock_token, :user_id => user.id)
      end
    end  
  end
  
  
end