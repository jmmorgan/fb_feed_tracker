require 'spec_helper'

describe ResourceMailer do

  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it "should generate an item email" do
  	ActionMailer::Base.deliveries.count.should == 0
  	ResourceMailer.send_item_email("act-111", "Indianapolis Clowns", "post-222", "We're ready!", "joe@9mmedia.com").deliver
  	ActionMailer::Base.deliveries.count.should == 1
  	message = ActionMailer::Base.deliveries.first
  	message.body.should =~ /We're ready!/
  end
end