module OmniAuth
  module Strategies
   
  end
end


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FBFT_APP_KEY'], ENV['FBFT_APP_SECRET'], 
    :scope => 'email,offline_access,read_stream,user_photos,friends_photos,read_friendlists,read_mailbox,manage_notifications,read_requests,user_subscriptions'
end