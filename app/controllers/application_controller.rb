class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "workers of the world, unite!"
  end
end
