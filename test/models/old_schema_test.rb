# == Schema Information
#
# Table name: old_schemas
#
#  id          :integer          not null, primary key
#  oldid       :integer
#  schema_id   :integer
#  import_date :datetime
#  username    :string
#  name        :string
#  template    :boolean          default(FALSE)
#  db          :string
#  schema_data :string
#  imported    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class OldSchemaTest < ActiveSupport::TestCase
  should belong_to(:schema)

  should 'be not imported by default' do
    assert_equal false, OldSchema.new.imported?
  end

  should 'convert to schema' do
    skip
  end
end
