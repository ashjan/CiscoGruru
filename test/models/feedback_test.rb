# == Schema Information
#
# Table name: feedbacks
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  subject     :string
#  message     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  client_info :text
#  answered    :boolean          default(FALSE)
#

require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  should belong_to(:user)

  test 'should have a user_email' do
    assert_equal 'me@cenanozen.com', feedbacks(:one).user_email
  end

  test 'should not have a user_email if no user present' do
    assert_nil feedbacks(:two).user_email
  end

  test 'should have a username' do
    assert_equal 'kedibasi', feedbacks(:one).username
  end

  test 'should not have a username if no user present' do
    assert_nil feedbacks(:two).username
  end
end
