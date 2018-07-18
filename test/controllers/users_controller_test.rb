require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context 'account page' do
    should 'render account page for a logged in user' do
      login_as(:cenan)
      get :account
      assert_response :success
      assert_template :account
    end

    should 'redirect to login page for guests' do
      get :account
      assert_redirected_to '/login'
    end
  end
end
