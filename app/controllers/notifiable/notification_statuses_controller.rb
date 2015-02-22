module Notifiable
  class NotificationStatusesController < Notifiable.api_controller_class
    before_filter :find_notification_status!, :check_authorisation!
  
    def opened      
      if @notification_status.opened!
        head :status => :ok
      else
        render :json => { :errors => @notification_status.errors.full_messages }, :status => :unprocessable_entity
      end
    
    end
  
    private
    def find_notification_status!
      return head :status => :not_acceptable unless params[:localized_notification_id] && params[:device_token_id]
          
      @notification_status = NotificationStatus.find_by_localized_notification_id_and_device_token_id!(params[:localized_notification_id], params[:device_token_id])
    end
  
    def check_authorisation!
      head :status => :unauthorized unless current_notifiable_user == @notification_status.device_token.user
    end
  end
end
