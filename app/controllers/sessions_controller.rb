class SessionsController < ApplicationController
  def new
  end

  def create
	  # Pulls the user out of the database using the submitted email address. The && is used to determine if the user is valid.
	  user = User.find_by(email: params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
		  # log the user ...
		  log_in user
		  redirect_to user
	  else
		  flash.now[:danger] = 'Invalid email/password combination'
		  render 'new'
	  end
  end

  def destroy
	  log_out
	  redirect_to root_url
  end
end
