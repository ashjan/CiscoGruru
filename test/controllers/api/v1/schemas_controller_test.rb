require 'test_helper'

class SchemasControllerTest < ActionController::TestCase
  tests API::V1::SchemasController

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  test 'should list of schemas for current user' do
    login_as(:cenan)
    get :index
    assert_response :success
    assert_equal Mime::JSON, response.content_type
    schemas = JSON.parse(response.body, symbolize_names: true)[:own_schemas]
    titles = schemas.collect {|s| s[:title]}
    assert_includes titles, 'schema1'
    assert_not_includes titles, 'schema2'
  end

  test 'should list templates' do
    get :templates
    assert_response :success
    assert_equal Mime::JSON, response.content_type
    schemas = JSON.parse(response.body, symbolize_names: true)
    assert_equal schemas.count, Schema.templates.not_deleted.count
  end

  test 'returns list of schemas shared with the current user' do
    skip
  end

  test 'should fail to show a schema if owner is wrong' do
    get :show, id: schemas(:one)
    assert_response :unauthorized
    assert_equal Mime::JSON, response.content_type
    result = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'You are not logged in', result[:message]
  end

  test 'should render a schema' do
    login_as(:cenan)
    get :show, id: schemas(:one).id
    assert_response :success
    assert_equal Mime::JSON, response.content_type
    schema = JSON.parse(response.body, symbolize_names: true)
    assert_equal schemas(:one).title, schema[:title]
  end

  test 'should fail to create a new schema when the user is not signed in' do
    post :create, {
      title: 'deneme',
      schema_data: ''
    }
    assert_response :unauthorized
  end

  test 'should create a new schema' do
    login_as(:cenan)
    post :create, {
      title: 'deneme',
      schema_data: ''
    }
    assert_response :created
    result = JSON.parse(response.body, symbolize_names: true)
    schema = Schema.find result[:id]
    assert_equal users(:cenan), schema.owner
    assert_equal 'deneme', schema.title
  end

  test 'should fail to update a schema that does not belong to current user' do
    schema = schemas(:two)
    assert_equal schema.owner, users(:meral)
    login_as(:cenan)

    post :update, {
      id: schema.id,
      title: "different title"
    }
    assert_response :unauthorized
  end

  test 'should update an existing schema' do
    schema = schemas(:two)
    initial_title = schema.title
    assert_equal schema.owner, users(:meral)
    login_as(:meral)

    post :update, {
      id: schema.id,
      title: initial_title + "_changed"
    }

    assert_response :success
    schema.reload
    assert_equal initial_title + "_changed", schema.title
  end

  test 'should delete a schema' do
    schema = schemas(:one)
    assert_equal false, schema.deleted?
    login_as(:cenan)
    delete :destroy, {
      id: schema.id
    }
    assert_response :success

    schema.reload
    assert_equal true, schema.deleted?
  end

  test 'should generate sql for a schema data' do
    skip
  end
end
