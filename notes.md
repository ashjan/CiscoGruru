# Plans

## TODO

Yandex: find font-awesome icon

Dropbox:
https://github.com/bamorim/omniauth-dropbox-oauth2

## Multithreaded Server

Possible Application Servers:

* Puma
* Thin

### Changes

[Change dalli configuration](https://github.com/mperham/dalli#multithreading-and-rails)

If you use Puma or another threaded app server, as of Dalli 2.7, you can use a pool of Dalli clients with Rails to ensure the `Rails.cache` singleton does not become a source of thread contention. You must add `gem 'connection_pool'` to your Gemfile and add :pool_size to your `dalli_store` config:

config.cache_store = :dalli_store, 'cache-1.example.com', { :pool_size => 5 }
You can then use the Rails cache as normal and Rails.cache will use the pool transparently under the covers, or you can check out a Dalli client directly from the pool:

Rails.cache.fetch('foo', :expires_in => 300) do
  'bar'
end

Rails.cache.dalli.with do |client|
  # client is a Dalli::Client instance which you can
  # use ONLY within this block
end


User
  has_one account
  after_create :create_account

Account
  has_many users
  has_many payments
  enum account_type

Payment
  belong_to account
  amount float
  enum payment_type [PAYPAL]
  enum status [INCOMPLETE, COMPLETED, CANCELED, FAILED]