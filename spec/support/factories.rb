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
  end
  
  factory :notification_status, :class => Notifiable::NotificationStatus do
    notification
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