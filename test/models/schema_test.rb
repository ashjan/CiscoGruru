# == Schema Information
#
# Table name: schemas
#
#  id                    :integer          not null, primary key
#  title                 :string
#  schema_data           :string
#  owner_id              :integer
#  created_at            :datetime
#  updated_at            :datetime
#  description           :text
#  template              :boolean          default(FALSE)
#  deleted               :boolean          default(FALSE)
#  schema_versions_count :integer          default(0)
#  db                    :string
#

require 'test_helper'

class SchemaTest < ActiveSupport::TestCase
  should have_many(:user_schemas)
  should have_many(:users)
  should belong_to(:owner)
  should validate_presence_of(:owner)

  should 'generate a text description' do
  	schema = schemas(:school_schema)
  	schema.generate_description

  	assert_equal '1 tables, 0 notes', schema.description
  end
end
