FactoryGirl.define do

  factory :mock_token, :class => Notifiable::DeviceToken do
    provider :mock
    sequence(:token) {|n| "ABCD#{n}" }
    app
  end
  
  factory :app, :class => Notifiable::App do
  end
  
  factory :notification, :class => Notifiable::Notification do
    app
  end
  
  
  factory :notification_status, :class => Notifiable::NotificationStatus do
    notification
    status 0
  end
  
  sequence(:email) {|n| "person-#{n}@example.com" }
  
  factory :user do
    email
    
    factory :user_with_mock_token do
      after(:create) do |user, evaluator|
        FactoryGirl.create(:mock_token, :user_id => user.id)
      end
    end
  
    factory :user_with_invalid_mock_token do
      after(:create) do |user, evaluator|
        FactoryGirl.create(:mock_token, :user_id => user.id, :is_valid => false)
      end
    end  
  end
  
  
end