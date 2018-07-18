class Guest
  def id
    nil
  end

  def username
    "Guest"
  end

  def email
    "nobody@dbdesigner.net"
  end

  def schemas
    Schema.none
  end

  def own_schemas
    Schema.none
  end

  def feedbacks
    Feedback.none
  end

  def oauth_profiles
    OAuthProfile.none
  end

  def image
    ""
  end

  def id_hash
    0
  end

  def created_at
    Time.zone.now
  end

  def is_signed_in?
    false
  end
end
