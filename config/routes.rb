  
Notifiable::Engine.routes.draw do

	resources :device_tokens, :only => [:create, :destroy]

end