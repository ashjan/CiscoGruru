require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  setup do
    @new_user_params = {
      user: {
        username: 'test',
        email: 'test@test.com',
        password: 'password',
        password_confirmation: 'password'
      }
    }
  end

  test 'should render new registration page' do
    get :new
    assert_response :success
  end

  test 'should redirect /registrations to new registration page' do
    get :index
    assert_redirected_to new_registration_path
  end

  test 'should create a new user and login the new user' do
    post :create, @new_user_params
    assert_redirected_to designer_path
  end

  # NOTE: disabled admin mail
  #test 'should send an admin.registration mail' do
  #  assert_difference('ActionMailer::Base.deliveries.size', 1) do
  #    post :create, @new_user_params
  #  end
  #end

  test 'should render new page when the registration is not successful' do
    post :create, {
      user: {
        username: 'test',
        email: 'test@test.com',
        password: 'password',
        password_confirmation: 'wrong confirmation'
      }
    }
    assert_response :success
    assert_template :new
  end
end
