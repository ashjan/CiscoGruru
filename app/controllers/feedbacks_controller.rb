class FeedbacksController < ApplicationController
  # POST /feedbacks
  #
  # save user feedback and queue a mail report
  def create
    feedback = Feedback.new({
    	subject: params[:subject],
    	message: params[:message],
    	client_info: params[:client_info]
    	})
    if current_user.is_signed_in?
      feedback.user = current_user
    end
    feedback.save
    AdminMailer.feedback(feedback.id).deliver_later
    head 200
  end

  # GET /feedbacks/:id/toggle_answered
  def toggle_answered
    feedback = Feedback.find params[:id]
    feedback.update :answered => true
    redirect_to "/yonetim/feedback/#{feedback.id}"
  end
end
