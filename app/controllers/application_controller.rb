class ApplicationController < ActionController::Base

	# para que los metodos esten disponibles en los templates
	helper_method :current_user, :logged_in?

	def current_user
		# memoization: no corras el codigo si ya existe @current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	def logged_in?
		!!current_user
	end

	def require_user
		if !logged_in?
			flash[:error] = "Must be logged in to do that"
			redirect_to root_path
		end
	end

	def require_admin
		access_denied unless logged_in? and current_user.admin?
	end

	def access_denied
		flash[:error] = "You can't do that"
		redirect_to root_path
	end

end
