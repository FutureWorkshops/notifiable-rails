# frozen_string_literal: true

class AddAppIdTokenIndexToNotifiableDeviceTokens < ActiveRecord::Migration[4.2]
  def change
    add_index :notifiable_device_tokens, %i[app_id token], unique: true
  end
end
