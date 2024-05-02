class SessionsController < ApplicationController
    def new
        render "home/login"
    end

    def create
        @user = User.find_by(email: params[:email])

        if @user.present? && @user.authenticate(params[:password]) # authenticate works with has_secure_password in your User model to match hash values
            if @user.status == true
                session[:user_id] = @user.id 
                @user.touch # Update updated_at timestamp
                flash[:notice] = "Welcome back, #{@user.name}"
                redirect_to users_path
              else
                flash[:alert] = "Your account has been blocked. Please contact the UserManager administrator."
                redirect_to login_path
              end
        else
            flash[:alert] = "The Email or password you have provided is incorrect. Please try again."
            render "home/login", status: :unprocessable_entity
        end
    end

    def destroy
        session[:user_id] = nil
        flash[:notice] = "You have been logged out."
        redirect_to root_path
    end

end
