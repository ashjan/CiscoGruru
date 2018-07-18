class UserMailer < ApplicationMailer

  # Invitation to collaborate on a schema
  #
  # @param [User] inviter
  # @param [User] invitee
  # @param [String] token
  def collaboration_invitation(inviter:, invitee:, token:)
    @invitee = invitee
    @inviter = inviter
    @token = token
    mail to: invitee.email, subject: 'DbDesigner.net invitation'
  end

  # Password recovery e-mail
  #
  # @param [User] user
  # @param [String] token
  def password_recovery(user:, token:)
    @token = token
    mail to: user.email, subject: 'DbDesigner.net password recovery'
  end

end
