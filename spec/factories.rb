FactoryGirl.define do
  factory :apns_token, :class => FwtPushNotificationServer::DeviceToken do
    provider :apns
    token "ABC1234"
  end
  
  factory :user_with_apns_token, :class => User do
    email "matt@futureworkshops.com"
    after(:build) do |user, evaluator|
      apns_token = FactoryGirl.build(:apns_token)
      apns_token.user_id = user.email
      apns_token.save!
    end
  end
end