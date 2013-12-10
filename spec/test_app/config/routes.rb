Rails.application.routes.draw do

  mount FwtPushNotificationServer::Engine => "/fwt_push_notification_server"
end
