  
Notifiable::Engine.routes.draw do
	resources :device_tokens, :only => [:create, :destroy]
	put 'notifications/opened', :to => "notifications#opened"
end