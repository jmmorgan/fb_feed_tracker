class WelcomeController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => [:do_check]

  def index

  end

  def omniauth_callback
    @omniauth_hash = request.env["omniauth.auth"]
  end

  def do_check
  	require 'fb_feed_tracker' #TODO.  Fix this.
  	tracker = Object.new.extend FbFeedTracker
    tracker.run_check(params[:access_token], params[:feed_id], params[:emails].split(","))
  end
end