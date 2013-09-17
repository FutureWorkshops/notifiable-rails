FwtPushNotificationServer::Engine.routes.draw do
  
	resources :device_tokens, only: [:create, :index]
	root :to => 'device_tokens#index'

	devise_for :users, {
    	class_name: 'FwtPushNotificationServer::User',
    	module: :devise
  	}

end
