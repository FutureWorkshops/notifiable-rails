require 'spec_helper'

describe ActiveRecord::Base do

  let(:notification_status) { FactoryGirl.build(:notification_status) }
  let(:notification_status2) { FactoryGirl.build(:notification_status) }
  
  it "generates correct Oracle Enchanced Bulk SQL" do 
    date = DateTime.now
    sql = Notifiable::NotificationStatus.send(:oracle_bulk_insert_sql, 
      [{notification_id: notification_status.notification.id, device_token_id: notification_status.device_token.id, status: 0, created_at: date},
      {notification_id: notification_status2.notification.id, device_token_id: notification_status2.device_token.id, status: 0, created_at: date}])
    
      sql.should eql "INSERT ALL INTO notifiable_statuses (created_at, device_token_id, notification_id, status) VALUES (#{ActiveRecord::Base.connection.quote(date)}, 1, 1, 0) INTO notifiable_statuses (created_at, device_token_id, notification_id, status) VALUES (#{ActiveRecord::Base.connection.quote(date)}, 2, 2, 0) SELECT 1 FROM DUAL;"
  end
end
