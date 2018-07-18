class Rack::Attack
  ### Throttle Spammy Clients ###

  # If any single client IP is making tons of requests, then they're
  # probably malicious or a poorly-configured scraper. Either way, they
  # don't deserve to hog all of the app server's CPU. Cut them off!
  #
  # Note: If you're serving assets through rack, those requests may be
  # counted by rack-attack and this throttle may be activated too
  # quickly. If so, enable the condition to exclude them from tracking.

  # Throttle all requests by IP (60rpm)
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', :limit => 300, :period => 5.minutes) do |req|
    req.ip unless req.path.starts_with?('/assets')
  end

  ### Prevent Brute-Force Login Attacks ###

  # The most common brute-force login attack is a brute-force password
  # attack where an attacker simply tries a large number of emails and
  # passwords to see if any credentials match.
  #
  # Another common method of attack is to use a swarm of computers with
  # different IPs to try brute-forcing a password for a specific account.

  # Throttle POST requests to /login by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
  throttle('logins/ip', :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/sessions' && req.post?
      req.ip
    end
  end

  # Throttle POST requests to /login by email param
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/email:#{req.email}"
  #
  # Note: This creates a problem where a malicious user could intentionally
  # throttle logins for another user and force their login requests to be
  # denied, but that's not very common and shouldn't happen to you. (Knock
  # on wood!)
  throttle("logins/email", :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/sessions' && req.post?
      # return the email if present, nil otherwise
      req.params['email'].presence
    end
  end

  throttle("comments/ip", limit: 5, period: 1.minute) do |req|
    if req.path =~ /\/api\/v1\/schemas\/.*\/schema_comments/ && req.post?
      req.ip
    end
  end

  # https://github.com/kickstarter/rack-attack/wiki/Advanced-Configuration#blacklisting-from-railscache
  #
  # to block an ip from rails console:
  #
  #     Rails.cache.write('block 1.2.3.4', true, expires_in: 5.days)
  #
  # to create an alias in ~/.irbrc
  #
  # def block_ip ip
  #   Rails.cache.write("block #{ip}", true, expires_in: 2.days)
  # end
  #
  Rack::Attack.blocklist('block <ip>') do |req|
    # if variable `block <ip>` exists in cache store, then we'll block the request
    Rails.cache.fetch("block #{req.ip}").present?
  end

  ### Custom Throttle Response ###

  # By default, Rack::Attack returns an HTTP 429 for throttled responses,
  # which is just fine.
  #
  # If you want to return 503 so that the attacker might be fooled into
  # believing that they've successfully broken your app (or you just want to
  # customize the response), then uncomment these lines.
  self.throttled_response = lambda do |env|
   [ 503,  # status
     {},   # headers
     ['']] # body
  end
end
