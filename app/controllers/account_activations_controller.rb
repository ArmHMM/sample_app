class AccountActivationsController < ApplicationController

	#added feb 19, 2020
	def edit
		user = User.find_by(email: params[:email])
		if user && !user.activated? && user.authenticated?(:activation, params[:id])
			#user.update_attribute(:activated, true)
			#user.update_attribute(:activated_at, Time.zone.now)
			user.activate # modified feb 19, 2020
			log_in user
			flash[:success] = "Account activated!"
			redirect_to user
		else
			flash[:danger] = "Invalid activation link"
			redirect_to root_url
		end
	end
end
