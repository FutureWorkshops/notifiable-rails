
module Notifiable
  
  class DeviceTokensController < Notifiable.api_controller_class

    before_filter :verify_permissions

    def create
      @device_token = DeviceToken.find_or_create_by(:token => params[:token])
      @device_token.update_attributes({
        :user_id => params[:user_id],
        :provider => params[:provider]
      })

      user = @device_token.user
      user.update_attributes(user_info_params) unless user_info_params.nil? && user.nil?

      if @device_token.save
        render :json => { :status => 0 }
      else
        render :json => { :errors => @device_token.errors.full_messages }
      end
    end

    def destroy
      @device_token = DeviceToken.find_by(:token => params[:id])
      if @device_token.nil? || @device_token.update_attribute(:user_id, nil)
        render :json => { :status => 0 }
      else
        render :json => { :errors => @device_token.errors.full_messages }
      end
    end

    private

      def verify_permissions
        unless self.respond_to?(:can_update?)
          raise "Base controller class for Notifiable has to implement 'can_update?(user_id) -> true or false'"
        else
          head :unauthorized unless params[:user_id] && can_update?(params[:user_id])
        end
      end

      def user_info_params
        unless params[:user].nil? || Notifiable.permitted_user_attributes.nil?
          params[:user].permit(Notifiable.permitted_user_attributes)
        else
          nil
        end
      end

  end
  
end
