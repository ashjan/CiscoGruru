# == Schema Information
#
# Table name: schema_comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  schema_id  :integer
#  contents   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class SchemaCommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
