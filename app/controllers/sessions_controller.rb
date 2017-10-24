class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      redirect_to user
    else
      # we use danger because alert-danger is
      # a bootstrap class.
      flash.now[:danger] = "Bad Login, Baby."
      render 'new'
    end
  end

  def destroy
    log_out(current_user)
    redirect_to root_url
  end
end
