require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  test 'should render index page' do
    get :index
    assert_response :success
    assert_template :index
  end
end
