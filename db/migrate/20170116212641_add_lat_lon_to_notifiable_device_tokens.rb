class AddLatLonToNotifiableDeviceTokens < ActiveRecord::Migration
  
  def change
    enable_extension "postgis"
    add_column :notifiable_device_tokens, :lonlat, :st_point, geographic: true
  end

end
