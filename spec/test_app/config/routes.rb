Rails.application.routes.draw do

  mount Notifiable::Engine => "/notifiable"
end
