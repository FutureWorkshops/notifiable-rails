class ApplicationController < ActionController::Base
  
  include ActionController::MimeResponds
  
  respond_to :json
  
  def current_notifiable_user
    User.find_by_email(params[:user_email])
  end

end
