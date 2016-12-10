class AddBadgeCountToNotifiableNotifications < ActiveRecord::Migration[5.0]
  
  def change
    add_column :notifiable_notifications, :badge_count, :integer
  end

end
