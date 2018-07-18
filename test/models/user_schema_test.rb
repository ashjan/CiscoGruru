# == Schema Information
#
# Table name: user_schemas
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  schema_id   :integer
#  access_mode :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class UserSchemaTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:schema)
end
