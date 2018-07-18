# == Schema Information
#
# Table name: oauth_profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  token      :string
#  secret     :string
#  username   :string
#  email      :string
#  firstname  :string
#  lastname   :string
#  image_url  :string
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class OAuthProfileTest < ActiveSupport::TestCase
  should belong_to(:user)
end
