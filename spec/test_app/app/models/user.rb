class User < ActiveRecord::Base
  devise :notifiable, :database_authenticatable
end
