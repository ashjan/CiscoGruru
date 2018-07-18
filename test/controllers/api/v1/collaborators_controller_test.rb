require 'test_helper'

class CollaboratorsControllerTest < ActionController::TestCase
  tests API::V1::CollaboratorsController

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
    @schema = schemas(:shared_schema)
  end

  should 'list collaborators for a schema' do
    # login_as(:cenan)
    get :index, schema_id: @schema.id
    assert_response :success
    assert_equal Mime::JSON, response.content_type
    collaborators = JSON.parse(response.body, symbolize_names: true)
    usernames = collaborators.collect {|c| c[:username]}
    assert_includes usernames, 'kedibasi'
    assert_includes usernames, 'efe'
    assert_not_includes usernames, 'zarife'
  end

  should 'create a new collaborator' do
    assert_difference '@schema.users.count', 1 do
      assert_difference 'User.count', 1 do
        post :create, {
          schema_id: @schema.id,
          email: 'falan@filan.com',
          send_email: false
        }
      end
    end
    assert_response :success
  end

  should 'add an existing user as a collaborator' do
    assert_difference '@schema.users.count', 1 do
      assert_no_difference 'User.count' do
        post :create, {
          schema_id: @schema.id,
          email: 'meral@cenanozen.com',
          send_email: false
        }
      end
    end
    assert_response :success
  end

  should 'remove a collaborator from a schema' do
    assert_difference '@schema.users.count', -1 do
      delete :destroy, {
        schema_id: @schema.id,
        id: users(:kedibasi).id
      }
    end
    assert_response :success
  end
end
