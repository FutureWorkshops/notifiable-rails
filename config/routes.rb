  
Notifiable::Engine.routes.draw do
	resources :device_tokens, :only => [:create, :update, :destroy]
	put 'notifications/opened', :to => "notifications#opened"
end