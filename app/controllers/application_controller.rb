class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize

  delegate :allow?, to: :current_permission
  helper_method :allow?

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def current_permission
      @current_permission ||= Permission.new(current_user)
    end

    def current_resource
      nil
    end

    def authorize
      unless current_permission.allow?(params[:controller], params[:action], current_resource)
        unauthorized
      end
    end

    def unauthorized
      flash[:danger] = 'Not authorized'
      redirect_to root_url
    end
end
