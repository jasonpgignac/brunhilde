class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  protected
  def render_404
    render :file => "#{Rails.root}/public/404.html", :status => "404"
  end
  private
        def current_user_session
          return @current_user_session if defined?(@current_user_session)
          @current_user_session = UserSession.find
        end

        def current_user
          return @current_user if defined?(@current_user)
          @current_user = current_user_session && current_user_session.user
        end
  
end
