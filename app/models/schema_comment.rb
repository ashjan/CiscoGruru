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

class SchemaComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :schema

  validates :user, presence: true
  validates :schema, presence: true
end
