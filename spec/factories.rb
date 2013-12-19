FactoryGirl.define do
  factory :apns_token, :class => FwtPushNotificationServer::DeviceToken do
    provider :apns
    token
  end
  
  sequence(:email) {|n| "person-#{n}@example.com" }
  sequence(:token) {|n| "ABCD#{n}" }
  
  factory :user_with_apns_token, :class => User do
    email
    after(:build) do |user, evaluator|
      apns_token = FactoryGirl.build(:apns_token)
      apns_token.user_id = user.email
      apns_token.save!
    end
  end
  
  factory :user_with_invalid_apns_token, :class => User do
    email
    after(:build) do |user, evaluator|
      apns_token = FactoryGirl.build(:apns_token)
      apns_token.user_id = user.email
      apns_token.is_valid = false
      apns_token.save!
    end
  end
  
end