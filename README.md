Installation:

1. Create new Rails app

2. In Gemfile add:
gem 'fwt_push_notification_server'

3. Run bundle update

4. Copy your APNS certificate into the Rails app

5. Mount engine routes in routes.rb

  mount FwtPushNotificationServer::Engine => "/"

6. Run rails g fwt_push_notification_server:install

7. Customize settings in config/initializers/fwt_push_notification_server.rb and db/seeds.db

8. Run rake db:migrate && rake db:seed

Done!
