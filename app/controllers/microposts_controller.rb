class MicropostsController < ApplicationController
  before_action :logged_in_user, [:create, :destroy]

  def create
  end

  def destroy
  end
end
