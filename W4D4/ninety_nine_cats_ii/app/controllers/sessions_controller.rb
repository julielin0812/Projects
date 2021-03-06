class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
      @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
      if @user.nil?
        flash.now[:errors] = ["Invalid username / password"]
        render :new
      else
        login!(@user)
        redirect_to cats_url
      end
  end

  def destroy
    logout!
    redirect_to :new_session_url
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
