class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # we use danger because alert-danger is
      # a bootstrap class.
      flash.now[:danger] = "Bad Login, Baby."
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
