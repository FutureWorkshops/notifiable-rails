Notifiable.configure do |config|
  
  # The size of the batch of Notification Statuses kept in memory
  # before being saved. This should be varied with the heap size of the process
  # sending the notifications. Defaults to 10,000.
  #config.notification_status_batch_size = 10000
  
  # Set the delivery method to test, preventing notifications from being sent
  # Defaults to :send
  #config.delivery_method = :test
  
  # Custom function to select the class for a provider
  # Defaults to nil
  #config.find_notifier_class do |notification, device|
  #  Notifiable.notifier_classes[device.provider]
  #end

end