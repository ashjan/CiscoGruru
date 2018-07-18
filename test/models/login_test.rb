# == Schema Information
#
# Table name: logins
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  logintime        :datetime
#  user_agent       :string
#  ip               :string
#  oauth_profile_id :integer
#  browser          :string
#  version          :string
#  platform         :string
#

require 'test_helper'

class LoginTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:oauth_profile)

  should validate_presence_of(:user)
end
