class PasswordResetsController < ApplicationController
  def new
  end
  
  def create                               
    user = User.find_by_email(params[:email])
    user.send_password_reset
    redirect_to root_path, notice: "Email sent with instructions to change your password."
  end
end
