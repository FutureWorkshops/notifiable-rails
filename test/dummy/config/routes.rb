Rails.application.routes.draw do

  mount FwtPushNotificationServer::Engine => "/"

end
