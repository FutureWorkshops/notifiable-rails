FactoryGirl.define do

  factory :apns_token, :class => FwtPushNotificationServer::DeviceToken do
    provider :apns
    token
  end
  
  factory :gcm_token, :class => FwtPushNotificationServer::DeviceToken do
    provider :gcm
    token
  end
  
  sequence(:email) {|n| "person-#{n}@example.com" }
  sequence(:token) {|n| "ABCD#{n}" }
  
  factory :user do
    email
    
    factory :user_with_apns_token do
      after(:build) do |user, evaluator|
        FactoryGirl.create(:apns_token, :user_id => user.email)
      end
    end
  
    factory :user_with_gcm_token do
      after(:build) do |user, evaluator|
        FactoryGirl.create(:gcm_token, :user_id => user.email)
      end
    end
  
    factory :user_with_invalid_apns_token do
      after(:build) do |user, evaluator|
        FactoryGirl.create(:apns_token, :user_id => user.email, :is_valid => false)
      end
    end  
  end
  
  
end