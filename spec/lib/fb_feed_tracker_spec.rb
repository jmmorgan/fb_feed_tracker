require 'spec_helper'

describe FbFeedTracker do

  before(:each) do
    ActionMailer::Base.deliveries.clear

    @item = {
    	"id" => "4004004",
    	"message" => "Don't shoot me.",
    	"from" => {
    		"id" => "42",
    		"name" => "Mariano Rivera"
    	}
    }

    require 'fb_feed_tracker'
    @tracker = Object.new.extend FbFeedTracker
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it "should not send the same post to the same recipient more than once" do
  	ActionMailer::Base.deliveries.count.should == 0

  	@tracker.send(:process_item, @item, ["joe@9mmedia.com"])
  	ActionMailer::Base.deliveries.count.should == 1
  	ActionMailer::Base.deliveries.clear

  	# Repeat item/email should not generate message
  	@tracker.send(:process_item, @item, ["joe@9mmedia.com"])
  	ActionMailer::Base.deliveries.count.should == 0

  	# Adding an email should result in one new message
  	@tracker.send(:process_item, @item, ["joe@9mmedia.com", "joe+1@9mmedia.com"])
  	ActionMailer::Base.deliveries.count.should == 1
  	ActionMailer::Base.deliveries.first.to.first.should == "joe+1@9mmedia.com"
  	ActionMailer::Base.deliveries.clear

  	# Changing item id should result in one new message
  	@item["id"] = "5005005"
  	@tracker.send(:process_item, @item, ["joe@9mmedia.com"])
  	ActionMailer::Base.deliveries.count.should == 1
  	ActionMailer::Base.deliveries.first.body.should =~ /5005005/
  	ActionMailer::Base.deliveries.clear



  end

end