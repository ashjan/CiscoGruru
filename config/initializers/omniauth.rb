OmniAuth.config.logger = Rails.logger
OmniAuth.config.full_host = 'https://dbdesigner.net'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '1f8b1187fb518660c773', 'b792e2f32638e507530d739e583c9b05ba5920ff'
  provider :google_oauth2, '995982304714-cvr1v3kqsor2d2p5q8kuf8bac37ceal0.apps.googleusercontent.com', 'NeOJ4VDZFkFv1lgWziRInQyl'
  provider :twitter, Rails.application.secrets.twitter_access_key, Rails.application.secrets.twitter_secret
  provider :vkontakte, '5054840', Rails.application.secrets.vk_secret, {scope: "email"}
  provider :yandex, 'd12f6b599fe044738ae0c73b86111e24', Rails.application.secrets.yandex_secret
  # provider :dropbox_oauth2, ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET']
end
