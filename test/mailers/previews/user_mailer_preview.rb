# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def collaboration_invitation
  	inviter = User.first
  	invitee =  User.last
    UserMailer.collaboration_invitation(inviter: inviter, invitee: invitee, token: 'test')
  end

  def password_recovery
  	verifier = ActiveSupport::MessageVerifier.new("secret")
  	token = verifier.generate({
        user_id: 7896,
        expires: 3.days.from_now})
  	safe_token = ::Base64.urlsafe_encode64(token)
  	UserMailer.password_recovery(user: User.first, token: safe_token)
  end
end
