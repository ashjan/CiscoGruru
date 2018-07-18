require 'test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  test 'should save a new feedback with the current user' do
    login_as(:cenan)
    post :create, {
      subject: 'test',
      message: 'test',
      client_info: ''
    }
    assert_response :success
    assert_equal users(:cenan).id, Feedback.last.user.id
  end

  test 'should save a feedback as guest' do
    post :create, {
      subject: 'test',
      message: 'test',
      client_info: ''
    }
    assert_response :success
    assert_nil Feedback.last.user
  end

  test 'should send an admin.feedback mail' do
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post :create, {
        subject: 'test',
        message: 'test',
        client_info: ''
      }
    end
  end
end
