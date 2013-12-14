class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :load_user

  private
	  def load_user
	  	@user = ::User.find("5295063b32328cf35d000001")
	  end

end
