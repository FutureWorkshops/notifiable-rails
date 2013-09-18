class DeviseCreateFwtPushNotificationServerUsers < ActiveRecord::Migration
  
  def change
    create_table(:fwt_push_notification_server_users) do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :fwt_push_notification_server_users, :email,                :unique => true, :name => "fwt_users_email_index"
    add_index :fwt_push_notification_server_users, :reset_password_token, :unique => true, :name => "fwt_users_reset_password_token_index"

  end

end
