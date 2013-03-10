class WelcomeController < ApplicationController

  def index

  end

  def omniauth_callback
    @omniauth_hash = request.env["omniauth.auth"]
  end
end