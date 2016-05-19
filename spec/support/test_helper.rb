# Returns true if a test user is logged in.
def is_logged_in?
	!session[:user_id].nil?
end

# Logs in a test user.
def log_in_as(user, options = {})
	#password = options[:password] || "password"
	remember_me = options[:remember_me] || "1"
	if request_test?
		post login_path, session: { email: user.email, password: user.password, remember_me: remember_me }
	else
		session[:user_id] = user.id
		@user = user
	end
end

# Returns true inside an integration(request) test.
def request_test?
	defined?(post_via_redirect)
end

