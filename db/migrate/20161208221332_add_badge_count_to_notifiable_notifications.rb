# frozen_string_literal: true

class AddBadgeCountToNotifiableNotifications < ActiveRecord::Migration[4.2]
  def change
    add_column :notifiable_notifications, :badge_count, :integer
  end
end
