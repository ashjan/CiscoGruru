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

class Schema < ActiveRecord::Base
  has_many :user_schemas
  has_many :users, through: :user_schemas
  has_many :schema_comments
  has_many :schema_versions

  belongs_to :owner, class_name: "User"

  validates :owner, presence: true

  scope :templates, -> { where(template: true) }
  scope :not_deleted, -> { where(deleted: false) }

  def generate_description
    data = JSON.parse(schema_data)
    update description: "#{data["tables"].count} tables, #{data["notes"].count} notes"
  rescue JSON::ParserError
    logger.error "invalid json, generate description fail for schema #{id}"
  end

  def generate_version(user:)
    schema_versions.create(user: user, schema_data: schema_data)
  end
end
