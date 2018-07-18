# == Schema Information
#
# Table name: articles
#
#  id           :integer          not null, primary key
#  title        :string
#  slug         :string
#  brief_html   :text
#  brief_md     :text
#  content_html :text
#  content_md   :text
#  is_sponsored :boolean
#  is_published :boolean
#  view_count   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Article < ActiveRecord::Base
  scope :published, -> { where(is_published: true) }

  def published_str
    if is_published?
      "Published"
    else
      "Draft"
    end
  end

  def url
    "/blog/#{slug}---#{id}"
  end
end
