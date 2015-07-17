  
Notifiable::Engine.routes.draw do
	resources :device_tokens, :only => [:create, :update, :destroy]
	put 'notification_statuses/opened', :to => "notification_statuses#opened"
end