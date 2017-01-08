module Notifiable
  class DeviceToken < ActiveRecord::Base
    belongs_to :app, :class_name => "Notifiable::App"
    has_many :notification_statuses, :class_name => "Notifiable::NotificationStatus"
    
    validates :token, presence: true, uniqueness: { scope: :app }
    validates :provider, presence: true
    validates :app, presence: true
    
  end

end
