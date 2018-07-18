# == Schema Information
#
# Table name: schema_versions
#
#  id          :integer          not null, primary key
#  schema_id   :integer
#  schema_data :text
#  user_id     :integer
#  autosave    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SchemaVersion < ActiveRecord::Base
  belongs_to :schema, counter_cache: true
  belongs_to :user
end
