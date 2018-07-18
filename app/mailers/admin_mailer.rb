class AdminMailer < ApplicationMailer
  def registration(user_id)
    @user = User.find(user_id)
    mail to: 'me@cenanozen.com', subject: 'dbdesigner registration'
  end

  def feedback(feedback_id)
  	@feedback = Feedback.find(feedback_id)
  	@user = @feedback.user || Guest.new
  	mail to: 'me@cenanozen.com', subject: 'dbdesigner feedback'
  end

  def wrong_credentials_alert(password, ip_address)
  	@password = password
  	@ip_address = ip_address
  	mail to: 'me@cenanozen.com', subject: 'dbdesigner WRONG ADMIN PASSWORD!!!1'
  end

  def daily_report(data)
    @data = data
    mail to: 'me@cenanozen.com', subject: 'dbdesigner daily report'
  end
end
