# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  username                :string
#  email                   :string
#  password_digest         :string
#  created_at              :datetime
#  updated_at              :datetime
#  invited                 :boolean          default(FALSE)
#  account_id              :integer
#  schemas_count           :integer          default(0)
#  deleted                 :boolean          default(FALSE)
#  app_settings            :string
#  newsletter_subscription :boolean          default(FALSE)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_secure_password
  should have_many(:user_schemas)
  should have_many(:feedbacks)
  should have_many(:oauth_profiles)
  should have_many(:own_schemas)
  should have_many(:logins)
  should have_many(:payments)
  should belong_to(:account)
  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)

  test 'should be signed in if current user' do
  	user = User.new
  	assert_equal true, user.is_signed_in?
  end

  test 'should have an image' do
  	cenan = users(:cenan)
  	assert_equal "avatar.com/cenan", cenan.image
  end

  test 'should have a gravatar image if no oauth profile present' do
  	meral = users(:meral)
  	assert_match /gravatar/, meral.image
  end

  test 'should mark a user as deleted' do
    skip
  end

  test 'should have an account' do
    assert_difference 'Account.count', 1 do
      user = User.create!(email: 'test', password: 'test', password_confirmation: 'test')
      assert_not_nil user.account
    end
  end

  test 'should create an account for all users' do
    assert_difference 'Account.count', User.where(account: nil).count do
      User.create_accounts
    end
  end
end
