# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  username                :string
#  email                   :string
#  password_digest         :string
#  created_at              :datetime
#  updated_at              :datetime
#  invited                 :boolean          default(FALSE)
#  account_id              :integer
#  schemas_count           :integer          default(0)
#  deleted                 :boolean          default(FALSE)
#  app_settings            :string
#  newsletter_subscription :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  has_secure_password

  has_many :user_schemas
  has_many :schemas, through: :user_schemas
  has_many :own_schemas, foreign_key: :owner_id, class_name: "Schema"

  has_many :feedbacks

  has_many :oauth_profiles

  has_many :logins

  has_many :payments

  belongs_to :account

  validates :email, :presence => true, :uniqueness => true

  after_create :create_associations

  def delete_user
    update deleted: true
  end

  def is_signed_in?
    true
  end

  def image
    if oauth_profiles.count > 0
      oauth_profiles.first.image_url
    else
      "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=50"
    end
  end

  def id_hash
    (id ^ 0xdeadc0de) * 10000 + 1000 + rand(9000)
  end

  def record_login(request:, oauth_profile: nil)
    Login.create({
      user: self,
      logintime: Time.now,
      ip: request.ip,
      user_agent: request.user_agent,
      oauth_profile: oauth_profile})
  end

  def last_login_time
    if logins.count > 0
      logins.order(logintime: :desc).first.logintime
    else
      Time.new(2000, 1, 1)
    end
  end

  # Temporary method to create account associations for old users
  def self.create_accounts
    where(account: nil).each do |user|
      user.create_account!
      user.save
    end
  end

  private

  def create_associations
    create_account
    save
  end
end
