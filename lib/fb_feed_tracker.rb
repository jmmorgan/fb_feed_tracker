module FbFeedTracker
  require 'fb_feed_tracker/http_utils'

  include FbFeedTracker::HttpUtils

  # Just the most quick and dirty algorithm for now.
  # Robustness, testing(!) and other proper non-cowboyesque stuff are for later
  def run_check(access_token, fb_id, emails)
    Rails.logger.info "Let's rock"

    # Hard code since to one day ago for now
    since = 1.day.ago.to_i
    count = 500 # Hack. SHould be big enough for our purposes.

    url = "https://graph.facebook.com/#{fb_id}/feed?access_token=#{access_token}&limit=#{count}&since=#{since}"

    raw_json = get_body(http_get(url))

    json = ActiveSupport::JSON.decode(raw_json)
    data = json["data"].to_a

    data.each do |item|
      if (nested_lookup(item, "from", "id") == fb_id)
      	process_item(item, emails)
      end
    end
  end

  private

   # Performs a nested lookup on the given hash using the given list of keys
    # E.g.: nested_lookup(my_hash, "foo", "bar", blah") will return either
    # the value of my_hash["foo"]["bar"]["blah"] or nil
    # if the full nested path cannot be traversed
    def nested_lookup(hash, *keys)
      result = nil
      count = keys.count
      keys.each_with_index do |key, i|
        break if !hash.kind_of?(Hash)
          
        if (i < (count - 1))
          hash = hash[key]
        else
          result = hash[key]
        end
      end

      result
    end

    # Sends the given item to the given email addresses 
    # Tries to avoid repeat messages
    def process_item(item, emails)
      id = item["id"]
      name =  nested_lookup(item, "from", "name")
      account_id = nested_lookup(item, "from", "id")
      msg = item["msg"]
      
      emails.each do |email|
        # Really inefficient querying, but this is quick and dirty.  Performance concerns can wait until we have a need to address them
        ResourceMailer.send_item_email(account_id, name, id, msg, email)
      end

    end

end