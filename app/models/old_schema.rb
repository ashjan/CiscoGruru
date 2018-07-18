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

class OldSchema < ActiveRecord::Base
  belongs_to :schema

  # @param [User] user
  def import(user)
    ActiveRecord::Base.transaction do
      new_schema = user.own_schemas.create({
        title: name,
        schema_data: schema_data,
        db: db
        })
      update imported: true, schema_id: new_schema.id
      logger.info "Importing old schema #{id} as #{new_schema.id} for user #{user.id}"
    end
  end

  # @param [User] user
  # @return [Fixnum] imported schemata count
  def self.import_user_schemata(user)
    return 0 unless user.email

    imported_schema_count = 0

    username = user.email.partition("@").first
    where(imported: false).where(username: username).each do |old_schema|
      old_schema.import(user)
      imported_schema_count += 1
    end

    return imported_schema_count
  end
end
