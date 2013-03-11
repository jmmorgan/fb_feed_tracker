class ResourceMailer < ActionMailer::Base
  default from: "joseph_m_morgan@yahoo.com"

  # Send a Share Track email 
  def send_item_email(account_id, account_name, id, msg, to)
    @subject = "#{account_name} has posted something new to their feed"
    @msg = msg
    @url = "http://www.facebook.com/#{account_id}/posts/#{id}"
    mail(:to => to, :from => "joe@9mmedia.com", :subject => @subject)
  end
end