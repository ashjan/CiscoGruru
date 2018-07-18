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

class UserSchema < ActiveRecord::Base
  belongs_to :user
  belongs_to :schema

  enum access_mode: [
    :can_read, :can_read_write, :can_share
  ]

  def access_mode_integer
    UserSchema.access_modes[access_mode]
  end
end
