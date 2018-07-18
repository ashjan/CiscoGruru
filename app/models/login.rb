# == Schema Information
#
# Table name: logins
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  logintime        :datetime
#  user_agent       :string
#  ip               :string
#  oauth_profile_id :integer
#  browser          :string
#  version          :string
#  platform         :string
#

class Login < ActiveRecord::Base
  belongs_to :user
  belongs_to :oauth_profile

  validates :user, presence: true

  delegate :provider_str, :to => :oauth_profile, :allow_nil => true
end
