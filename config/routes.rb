  
Notifiable::Engine.routes.draw do
	resources :device_tokens, :only => [:create, :destroy]
	put 'notification_statuses/opened', :to => "notification_statuses#opened"
end