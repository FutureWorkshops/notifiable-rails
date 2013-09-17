
Devise.setup do |config|

  config.secret_key = '4ff950431d5a3daf1f05fe497407c7ce600946d516c2e389840364db6b72540cda4a215819761edbe2edf56d4e6e3863a6a6d274e8d7b6b4ac5fb69a3181f07f'
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.router_name = :fwt_push_notification_server
  
  # config.to_prepare do
    Devise::SessionsController.layout "fwt_push_notification_server/application"       
  # end

end



