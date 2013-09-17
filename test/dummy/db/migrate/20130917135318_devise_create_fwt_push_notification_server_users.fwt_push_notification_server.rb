# This migration comes from fwt_push_notification_server (originally 20130917134913)
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

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps
    end

    add_index :fwt_push_notification_server_users, :email,                :unique => true, :name => "fwt_users_email_index"
    add_index :fwt_push_notification_server_users, :reset_password_token, :unique => true, :name => "fwt_users_reset_password_token_index"
    # add_index :fwt_push_notification_server_users, :confirmation_token,   :unique => true
    # add_index :fwt_push_notification_server_users, :unlock_token,         :unique => true
  end
end
