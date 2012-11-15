class SessionsController < ApplicationController
  
  def new
  end
  
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to users_path, notice: "Logged in!" # TODO: redirect to root path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
  
end
