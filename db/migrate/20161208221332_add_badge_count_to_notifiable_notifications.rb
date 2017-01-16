class AddBadgeCountToNotifiableNotifications < ActiveRecord::Migration
  
  def change
    add_column :notifiable_notifications, :badge_count, :integer
  end

end
