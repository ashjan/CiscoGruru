# == Schema Information
#
# Table name: oauth_profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  token      :string
#  secret     :string
#  username   :string
#  email      :string
#  firstname  :string
#  lastname   :string
#  image_url  :string
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OAuthProfile < ActiveRecord::Base
  belongs_to :user

  def provider_str
    case provider
    when 'google_oauth2'
      'Google'
    when 'github'
      'Github'
    when 'twitter'
      'Twitter'
    when 'vkontakte'
      'VKontakte'
    when 'yandex'
      'Yandex'
    else
      'Social Network'
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |oauth_profile|
      oauth_profile.provider = auth.provider
      oauth_profile.uid = auth.uid
      oauth_profile.token = auth.credentials['token']
      oauth_profile.secret = auth.credentials.fetch('secret', '')
      oauth_profile.email = auth.info.fetch('email', '').try(:downcase)
      oauth_profile.username = auth.info.fetch('name', '')
      oauth_profile.firstname = auth.info.fetch('first_name', '')
      oauth_profile.lastname = auth.info.fetch('last_name', '')
      oauth_profile.image_url = auth.info.fetch('image', '')
      oauth_profile.save
    end
  end
end
