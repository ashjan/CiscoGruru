# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def registration
    AdminMailer.registration(User.last.id)
  end

  def feedback
    unless Feedback.exists?
      Feedback.create!({
        user: User.first,
        subject: "Test",
        message: "Lorem ipsum dolor sit amet",
        client_info: "{}"
        })
    end
    AdminMailer.feedback(Feedback.first.id)
  end
end
