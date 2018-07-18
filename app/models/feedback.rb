# == Schema Information
#
# Table name: feedbacks
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  subject     :string
#  message     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  client_info :text
#  answered    :boolean          default(FALSE)
#

class Feedback < ActiveRecord::Base
  belongs_to :user

  def user_agent
    @user_agent_str ||= JSON.parse client_info
    @user_agent_str.fetch('userAgent', '')
  rescue JSON::ParserError
    ""
  end

  def parse_agent_str
    @agent ||= UserAgent.parse(user_agent)
  end

  def browser
    parse_agent_str.browser
  end

  def version
    parse_agent_str.version
  end

  def platform
    parse_agent_str.platform
  end

  def short_agent_info
    "#{browser} #{version} on #{platform}"
  end

  delegate :username, to: :user, allow_nil: true
  delegate :email, to: :user, prefix: true, allow_nil: true
end
