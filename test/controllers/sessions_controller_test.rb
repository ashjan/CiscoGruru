class SessionsControllerTest < ActionController::TestCase
  test 'login page' do
    get :new
    assert_response :success
    assert_template :new
  end

  test 'should redirect /session to new login page' do
    get :index
    assert_redirected_to new_session_path
  end

  test 'login with invalid creditentials' do
    cenan = users(:cenan)
    post :create, {
      email: cenan.email,
      password: 'wrong password'
    }
    assert_response :success
  end

  test 'login with valid credentials' do
    cenan = users(:cenan)
    assert_nil session[:user_id]
    post :create, {
      email: cenan.email,
      password: 'test'
    }
    assert_redirected_to '/designer'
    assert_equal cenan.id, session[:user_id]
  end

  test 'should record user login' do
    cenan = users(:cenan)
    assert_difference('Login.count') do
      post :create, {
        email: cenan.email,
        password: 'test'
      }
    end
  end

  context 'after successful login' do
    setup do
      cenan = users(:cenan)
      post :create, {
        email: cenan.email,
        password: 'test'
      }
    end

    should 'logout' do
      assert_not_nil session[:user_id]
      get :destroy, {}
      assert_redirected_to login_path
      assert_nil session[:user_id]
    end
  end

  context 'password recovery' do
    should 'render forgot password page' do
      get :remind_password
      assert_response :success
      assert_template :remind_password
    end

    should "send recovery mail to a valid email address" do
      post :send_reminder, {
        email: users(:cenan).email
      }
      mail = ActionMailer::Base.deliveries.last
      assert_equal users(:cenan).email, mail['to'].to_s
      assert_equal "info@dbdesigner.net", mail['from'].to_s
      assert_redirected_to '/password-recovery/reminder-sent'
    end

    should "not send recovery mail to non-existing mail address" do
      post :send_reminder, {
        email: "unexisting.email.address@nowhere"
      }
      assert_redirected_to '/password-recovery/remind-password'
    end

    should "render password recovery page for a valid token" do
      users(:cenan).update password_reset_digest: 'foo'
      get :recover, token: 'foo'
      assert_response :success
      assert_template :recover
    end

    should 'handle invalid password reset links' do
      get :recover, token: 'invalid-token'
      assert_redirected_to '/password-recovery/remind-password'
    end
  end
end
