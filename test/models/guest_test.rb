require 'test_helper'

class GuestTest < ActiveSupport::TestCase
  setup do
    @guest = Guest.new
  end

  should 'have nil as id' do
    assert_nil @guest.id
  end

  should 'have guest properties' do
    assert_equal 'Guest', @guest.username
    assert_equal 'nobody@dbdesigner.net', @guest.email
  end

  should 'have no schemas' do
    assert_equal 0, @guest.schemas.count
    assert_equal 0, @guest.own_schemas.count
  end

  should 'have no feedbacks' do
    assert_equal 0, @guest.feedbacks.count
  end

  should 'have no oauth profiles' do
    assert_equal 0, @guest.oauth_profiles.count
  end

  test 'should be signed out if current user' do
    assert_equal false, @guest.is_signed_in?
  end
end